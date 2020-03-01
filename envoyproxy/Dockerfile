# v1.13.0
FROM envoyproxy/envoy@sha256:8e63e2c9edbd6cb0d9f6604f1b38e28660dad16327242899652ecab19ec104b9 AS build

# debian stretch 2020-02-24
FROM debian@sha256:ddb131307ad9c70ebf8c7962ba73c20101f68c7a511915aea3ad3b7ad47b9d20 AS debian

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    cmake \
    wget

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

# 2019-09-20
FROM linuxuser586/base@sha256:1c9395a69224a0be3ebe30436efca9692eb08a3b404627f3855b9c04b529a5d4

COPY --from=build /usr/local/bin/envoy /

COPY --from=debian /libjaegertracing.so /usr/local/lib/

COPY envoy.yaml /etc/envoy/

EXPOSE 9000

USER 9000:9000

ENTRYPOINT ["dumb-init", "--", "/envoy", "-c", "/etc/envoy/envoy.yaml"]