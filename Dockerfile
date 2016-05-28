FROM java:8
MAINTAINER Paul Krizak <paul.krizak@gmail.com>

ENV VERSION=6.0
ENV LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8

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

