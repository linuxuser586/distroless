# v1.16.2
FROM envoyproxy/envoy@sha256:8a1d010267ee291bb0e7f12bb24e43b255c771629d70482910bc1f13a56e6b2f AS build

# debian:buster-20201209
FROM debian@sha256:22d4552b9f96fd0ea943cb846d58b069d4df297673636055a3d984b3ccac6a28 AS debian

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    cmake \
    wget \
    dumb-init

WORKDIR /build

ENV version="0.4.2"
ENV vhash="21257af93a64fee42c04ca6262d292b2e4e0b7b0660c511db357b32fd42ef5d3"
ENV url="https://github.com/jaegertracing/jaeger-client-cpp/archive/v${version}.tar.gz"
ENV app_name=jaeger-client-cpp-${version}
ENV file=${app_name}.tar.gz

RUN wget -q -O $file $url; \
    export SHA_SUM=$(sha256sum  $file | awk '{print $1}'); \
    if [ $SHA_SUM != $vhash ]; then \
    echo "incorrect hash: $sha" \
    echo "expected: $vhash" \
    exit 1; \
    fi; \
    tar xf $file; \
    echo "ready to compile ${app_name}";

WORKDIR /build/${app_name}/build

RUN cmake -DCMAKE_BUILD_TYPE=Release ../

RUN make -j $(nproc)

RUN strip libjaegertracing.so.${version} -o /libjaegertracing.so



# gcr.io/distroless/base-debian10 2020-12-23
FROM gcr.io/distroless/base-debian10@sha256:60e9bb71b73ca0a92eb7c87c14d646ecbc5d4d221b9d924b827b8e6b450d5190

COPY --from=build /usr/local/bin/envoy /

COPY --from=debian /libjaegertracing.so /usr/local/lib/
COPY --from=debian /usr/bin/dumb-init /usr/bin/dumb-init

COPY envoy.yaml /etc/envoy/

EXPOSE 9000

USER 9000:9000

ENTRYPOINT ["dumb-init", "--", "/envoy", "-c", "/etc/envoy/envoy.yaml"]