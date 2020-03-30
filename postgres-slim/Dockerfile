FROM linuxuser586/postgres:11.6 AS standard

# 2019-09-20
FROM linuxuser586/base@sha256:1c9395a69224a0be3ebe30436efca9692eb08a3b404627f3855b9c04b529a5d4

ENV PATH=/usr/local/pgsql/bin:$PATH

COPY --from=standard /usr/local/pgsql/bin/postgres /usr/local/pgsql/bin/postgres
COPY --from=standard /usr/local/pgsql/bin/vacuumdb /usr/local/pgsql/bin/vacuumdb
COPY --from=standard /usr/local/pgsql/lib /usr/local/pgsql/lib
COPY --from=standard /usr/local/pgsql/share /usr/local/pgsql/share
COPY --from=standard /etc/passwd /etc/passwd
COPY --from=standard /etc/group /etc/group

EXPOSE 5432

USER 5432:5432

ENTRYPOINT ["dumb-init", "--", "postgres", "-D", "/postgres/data", "-h", "0.0.0.0"]