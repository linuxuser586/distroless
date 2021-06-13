# v1.18.3
FROM envoyproxy/envoy@sha256:55d35e368436519136dbd978fa0682c49d8ab99e4d768413510f226762b30b07 AS build

# debian:buster-20210511
FROM debian@sha256:acf7795dc91df17e10effee064bd229580a9c34213b4dba578d64768af5d8c51 AS debian

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    build-essential \
    cmake \
    wget \
    dumb-init

WORKDIR /build

ENV version="0.7.0"
ENV vhash="3a3a03060bf5e3fef52c9a2de02e6035cb557f389453d8f3b0c1d3d570636994"
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



# gcr.io/distroless/base-debian10 2021-06-12
FROM gcr.io/distroless/base-debian10@sha256:6ec6da1888b18dd971802c2a58a76a7702902b4c9c1be28f38e75e871cedc2df

COPY --from=build /usr/local/bin/envoy /

COPY --from=debian /libjaegertracing.so /usr/local/lib/
COPY --from=debian /usr/bin/dumb-init /usr/bin/dumb-init

COPY envoy.yaml /etc/envoy/

EXPOSE 9000

USER 9000:9000

ENTRYPOINT ["dumb-init", "--", "/envoy", "-c", "/etc/envoy/envoy.yaml"]