# debian stretch 2020-03-29
FROM debian@sha256:ddb131307ad9c70ebf8c7962ba73c20101f68c7a511915aea3ad3b7ad47b9d20 AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    bzip2 \
    wget \
    libossp-uuid-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    locales

WORKDIR /build

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

COPY build.sh build.sh

RUN ./build.sh

RUN echo "host all all all md5" >> /postgres/data/pg_hba.conf

# 2019-09-20
FROM linuxuser586/base@sha256:1c9395a69224a0be3ebe30436efca9692eb08a3b404627f3855b9c04b529a5d4
# FROM gcr.io/distroless/base:debug

ENV PATH=/usr/local/pgsql/bin:$PATH

COPY --from=build /usr/local/pgsql /usr/local/pgsql

# default database
COPY --from=build /postgres /postgres

# needed for locale
COPY --from=build /etc/locale.alias /etc/locale.alias
COPY --from=build /usr/share/locale /usr/share/locale
COPY --from=build /usr/share/i18n /usr/share/i18n
COPY --from=build /usr/lib/locale /usr/lib/locale
COPY --from=build /usr/bin/locale /usr/bin/locale

# need for utilites
COPY --from=build /lib/x86_64-linux-gnu/libreadline.so.7 /lib/x86_64-linux-gnu/libreadline.so.7
COPY --from=build /lib/x86_64-linux-gnu/libtinfo.so.5 /lib/x86_64-linux-gnu/libtinfo.so.5
COPY --from=build /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1

# /bin/sh is need for initdb, which depends on popen
COPY --from=build /bin/sh /bin/sh

COPY passwd /etc/passwd
COPY group /etc/group

EXPOSE 5432

USER 5432:5432

ENTRYPOINT ["dumb-init", "--", "postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]

# use with debug
# ENTRYPOINT ["postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]