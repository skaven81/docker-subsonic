#!/bin/bash

PATH=/usr/bin:/usr/sbin:/bin:/sbin

if [ -n "${CONTAINER_IP}" ]; then
    echo "Setting container IP address to ${CONTAINER_IP}"
    ip addr flush dev eth0
    ip addr add ${CONTAINER_IP} dev eth0
    ip route add 0.0.0.0/0 via 192.168.1.1 dev eth0
fi

# Make sure /var/subsonic has links to all the right data bits
# it needs in /subsonic (the external volume)
cd /var/subsonic
for node in db db.backup lastfmcache jetty lucene lucene2 thumbs; do
    su nobody -s /bin/bash -c "mkdir -p /subsonic/$node"
    ln -s -f /subsonic/$node $node
done
ln -s -f /subsonic/subsonic.properties subsonic.properties

# Launch subsonic with --home=/var/subsonic, which
# the container has already prepped with symlinks
# into /subsonic (the external volume).  The logs
# and extraneous data will stay within the container,
# while the DB, thumbs, etc. will go out.
su nobody -s /bin/bash -c "/usr/bin/subsonic \
        --home=/var/subsonic \
        --port=4040 \
        --max-memory=1024 \
        --default-music-folder=/music \
        --default-podcast-folder=/podcasts \
        --default-playlist-folder=/playlists"
while [ ! -f /var/subsonic/subsonic.log ]; do
    sleep 1
done
tail -f /var/subsonic/subsonic.log
killall java
