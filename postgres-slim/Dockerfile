FROM linuxuser586/postgres:12.2 AS standard

# 2020-05-01
FROM gcr.io/distroless/base@sha256:2b0a8e9a13dcc168b126778d9e947a7081b4d2ee1ee122830d835f176d0e2a70

ENV PATH=/usr/local/pgsql/bin:$PATH

COPY --from=standard /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=standard /usr/local/pgsql/bin/postgres /usr/local/pgsql/bin/postgres
COPY --from=standard /usr/local/pgsql/lib /usr/local/pgsql/lib
COPY --from=standard /usr/local/pgsql/share /usr/local/pgsql/share
COPY --from=standard /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive
COPY --from=standard /etc/passwd /etc/passwd
COPY --from=standard /etc/group /etc/group

EXPOSE 5432

USER 5432:5432

ENTRYPOINT ["dumb-init", "--", "postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]