@"
FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

WORKDIR /root
RUN curl -sSLO ftp://ftp.bf-games.net/server-files/bf2/bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
RUN tar -zxvf bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
ENV INSTALLER=bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.sh
RUN sha256sum "`$INSTALLER" | grep "^$( $VARIANT['_metadata']['installer_sha256sum'] ) "
RUN sh "`$INSTALLER" --target /install --noexec --info
RUN sh "`$INSTALLER" --target /install --noexec
RUN cd /install
RUN mkdir -p /server
RUN cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh # Show the licenses without a pager
RUN cd /install && printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh # Agree to licenses


"@

if ('bf2hub' -in $VARIANT['_metadata']['components']) {
    @"
WORKDIR /root
RUN curl -ssLO https://www.bf2hub.com/downloads/BF2Hub-Unranked-Linux-R3.tar.gz
RUN sha256sum BF2Hub-Unranked-Linux-R3.tar.gz | grep '^c4b3d583741c500e930502e96c6a43a40f223868c9ca1111c70d80c7e6d2cd2b '
RUN tar -C /server/bf2 -zxvf BF2Hub-Unranked-Linux-R3.tar.gz -- bin start_bf2hub.sh
RUN ls -al /server/bf2
RUN mv /server/bf2/start_bf2hub.sh /server/bf2/start.sh
RUN chmod +x /server/bf2/bin/ia-32/libbf2hub.so /server/bf2/bin/amd-64/libbf2hub.so


"@
}

@"
FROM ubuntu:16.04 AS final
COPY --from=install /server /server
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /server/bf2
CMD [ "./start.sh" ]
"@
