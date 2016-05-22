FROM java:8
MAINTAINER Paul Krizak <paul.krizak@gmail.com>

ENV VERSION=6.0
ENV LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8

# Leave this blank to skip setting the container IP.
# If you set this to something, it must be in CIDR
# form, e.g. ip/mask.  The container must be executed
# with --cap-add=NET_ADMIN to allow changing the IP.
# If you are using Docker 1.10+, leave this blank and
# use the --ip= parameter to set the container's IP.
ENV CONTAINER_IP=192.168.1.45/24

VOLUME /music
VOLUME /playlists
VOLUME /podcasts
VOLUME /subsonic

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install libav-tools lame net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make the "nobody" user uid 99, to match RHEL (our container host)
RUN groupadd -g 99 nobody && \
    usermod -u 99 -g 99 -G nobody nobody

WORKDIR /var/subsonic
ADD [ "http://subsonic.org/download/subsonic-${VERSION}.deb", "subsonic.deb" ]
RUN dpkg -i subsonic.deb && rm subsonic.deb && \
    chown nobody.nobody /var/subsonic && \
    rm -f transcode/lame && \
    ln /usr/bin/lame transcode/lame

EXPOSE 4040
COPY [ "run_subsonic.sh", "run_subsonic.sh" ]
ENTRYPOINT [ "/var/subsonic/run_subsonic.sh" ]

