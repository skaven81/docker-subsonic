# Docker container for Subsonic

## Static IP Considerations

The Dockerfile is configured to set up a static IP for the container.
It does this by setting the `CONTAINER_IP` environment variable in
the Dockerfile, which is then read by the `run_subsonic.sh` script.
The `run_subsonic.sh` script then re-IP's the container.  This method
of setting the IP requires that the container be started with the
`--add-cap=NET_ADMIN` switch, which allows the container to modify
its network stack.  This is obviously insecure, but is required on
older Docker versions.

For newer versions of Docker (1.10+), delete or blank-out the
`CONTAINER_IP` environment variable in the Dockerfile.

## Building the container

Normal build process:

```
docker build -t subsonic .
```

## Volumes

The subsonic software will run as user `nobody` (UID=99),
so make sure that all of your mapped volumes are readable
and writable (except for the music dirs, which are read-only),
by that UID.

* `/subsonic` - stores the Subsonic database, thumbs, and preferences file
* `/playlists` - M3U playlists made by Subsonic users
* `/video` - Transcoded video is stored here
* `/podcasts` - Downloaded podcasts are stored here
* `/music` - read-only.  Base path to your music

## Network ports

Subsonic listens on port 4040 by default.  Adjust the
`--publish` list if you wish to have it listen on a
different port.

## Running Subsonic

### With an older Docker, with static IP

```
docker run -d --name=mysubsonic --cap-add=NET_ADMIN -p 4040:4040 \
    -v /path/to/subsonic-data:/subsonic \
    -v /path/to/playlists:/playlists \
    -v /path/to/video:/video subsonic
    -v /path/to/MP3s:/music/library1:ro \
    -v /raid/to/other_mp3:/music/library2:ro
```

### With a newer Docker, with static IP

```
docker run -d --name=mysubsonic --ip=192.168.1.55 -p 4040:4040 \
    -v /path/to/subsonic-data:/subsonic \
    -v /path/to/playlists:/playlists \
    -v /path/to/video:/video subsonic
    -v /path/to/MP3s:/music/library1:ro \
    -v /raid/to/other_mp3:/music/library2:ro
```

### Dynamic IP

```
docker run -d --name=mysubsonic --ip=192.168.1.55 -p 4040:4040 \
    -v /path/to/subsonic-data:/subsonic \
    -v /path/to/playlists:/playlists \
    -v /path/to/video:/video subsonic
    -v /path/to/MP3s:/music/library1:ro \
    -v /raid/to/other_mp3:/music/library2:ro
```

