ARG FIVEM_NUM=3184
ARG FIVEM_VER=3184-6123f9196eb8cd2a987a1dd7ff7b36907a787962
ARG DATA_VER=7cbf60059347751065c378c577eac0cd78b32e26

# Credit to Spritsail <https://github.com/spritsail> for the original image

FROM alpine as builder

ARG FIVEM_VER
ARG DATA_VER

WORKDIR /output

RUN wget -O- http://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz \
        | tar xJ --strip-components=1 \
            --exclude alpine/dev --exclude alpine/proc \
            --exclude alpine/run --exclude alpine/sys \
 && mkdir -p /output/opt/cfx-server-data \
 && wget -O- http://github.com/citizenfx/cfx-server-data/archive/${DATA_VER}.tar.gz \
        | tar xz --strip-components=1 -C opt/cfx-server-data \
    \
 && apk -p $PWD add tini mariadb-dev tzdata

ADD server.cfg opt/cfx-server-data
ADD entrypoint usr/bin/entrypoint

RUN chmod +x /output/usr/bin/entrypoint

#================

FROM scratch

ARG FIVEM_VER
ARG FIVEM_NUM
ARG DATA_VER

LABEL maintainer="Andruida <andruida@andruida.hu>" \
      org.label-schema.vendor="Andruida" \
      org.label-schema.name="FiveM" \
      org.label-schema.url="https://fivem.net" \
      org.label-schema.description="FiveM is a modification for Grand Theft Auto V enabling you to play multiplayer on customized dedicated servers." \
      org.label-schema.version=${FIVEM_NUM} \
      hu.andruida.version.fivem=${FIVEM_VER} \
      hu.andruida.version.fivem_data=${DATA_VER}

COPY --from=builder /output/ /

WORKDIR /config
EXPOSE 30120

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
