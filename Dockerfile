ARG RESTREAMER_UI_IMAGE=bekuzaa/bunny-streamer-ui:latest
ARG CORE_IMAGE=datarhei/base:alpine-core-latest
ARG FFMPEG_IMAGE=datarhei/base:alpine-ffmpeg-latest

FROM ${RESTREAMER_UI_IMAGE} AS restreamer_ui
FROM ${CORE_IMAGE} AS core
FROM ${FFMPEG_IMAGE}

COPY --from=core /core /core
COPY --from=restreamer_ui /ui/build /core/ui

ADD https://raw.githubusercontent.com/datarhei/restreamer/2.x/CHANGELOG.md /core/ui/CHANGELOG.md
COPY ./run.sh /core/bin/run.sh
COPY ./ui-root /core/ui-root

RUN ffmpeg -buildconf

ENV CORE_CONFIGFILE=/core/config/config.json
ENV CORE_DB_DIR=/core/config
ENV CORE_ROUTER_UI_PATH=/core/ui
ENV CORE_STORAGE_DISK_DIR=/core/data

EXPOSE 8080/tcp
EXPOSE 8181/tcp
EXPOSE 1935/tcp
EXPOSE 1936/tcp
EXPOSE 5000/udp
EXPOSE 6000/udp
EXPOSE 10000/udp

VOLUME ["/core/data", "/core/config"]
ENTRYPOINT ["/core/bin/run.sh"]
WORKDIR /core
