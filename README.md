# Docker container for Subsonic

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

### With a newer Docker, with static IP

```
docker run -d --name=mysubsonic --ip=192.168.1.55 -p 4040:4040 \
    --hostname=subsonic \
    -v /path/to/subsonic-data:/subsonic \
    -v /path/to/playlists:/playlists \
    -v /path/to/video:/video subsonic
    -v /path/to/MP3s:/music/library1:ro \
    -v /raid/to/other_mp3:/music/library2:ro
```

### Dynamic IP, for older Dockers

```
docker run -d --name=mysubsonic -p 4040:4040 \
    --hostname=subsonic \
    -v /path/to/subsonic-data:/subsonic \
    -v /path/to/playlists:/playlists \
    -v /path/to/video:/video subsonic
    -v /path/to/MP3s:/music/library1:ro \
    -v /raid/to/other_mp3:/music/library2:ro
```

