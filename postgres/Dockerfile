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
    locales \
    less \
    dumb-init

WORKDIR /build

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

COPY build.sh build.sh

RUN ./build.sh

RUN echo "host all all all md5" >> /postgres/data/pg_hba.conf

# 2020-05-01
FROM gcr.io/distroless/base@sha256:2b0a8e9a13dcc168b126778d9e947a7081b4d2ee1ee122830d835f176d0e2a70
# FROM gcr.io/distroless/base:debug

ENV PATH=/usr/local/pgsql/bin:$PATH
ENV TERM=xterm
ENV SHLVL=1

COPY --from=build /usr/local/pgsql /usr/local/pgsql
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init

# default database
COPY --from=build /postgres /postgres

# needed for locale
COPY --from=build /etc/locale.alias /etc/locale.alias
COPY --from=build /usr/share/locale /usr/share/locale
COPY --from=build /usr/share/i18n /usr/share/i18n
COPY --from=build /usr/lib/locale /usr/lib/locale
COPY --from=build /usr/bin/locale /usr/bin/locale

# need for utilites and extensions
COPY --from=build /lib/x86_64-linux-gnu/libreadline.so.7 /lib/x86_64-linux-gnu/libreadline.so.7
COPY --from=build /lib/x86_64-linux-gnu/libtinfo.so.5 /lib/x86_64-linux-gnu/libtinfo.so.5
COPY --from=build /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=build /bin/more /bin/more
COPY --from=build /bin/less /bin/less
COPY --from=build /lib/terminfo /lib/terminfo
COPY --from=build /usr/share/tabset /usr/share/tabset

# /bin/sh is need for initdb, which depends on popen
COPY --from=build /bin/dash /bin/sh

COPY passwd /etc/passwd
COPY group /etc/group

EXPOSE 5432

USER 5432:5432

ENTRYPOINT ["dumb-init", "--", "postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]

# use with debug
# ENTRYPOINT ["postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]