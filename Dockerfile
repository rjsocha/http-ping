# syntax=docker/dockerfile:1.5
FROM alpine AS build-layer
RUN apk --no-cache add gcc musl-dev make upx || apk --no-cache add gcc musl-dev make
COPY src/http-ping.c src/httpserver.h /build/
WORKDIR /build
RUN gcc -o http-ping -s -O2 -static http-ping.c && strip -x http-ping
RUN which upx && upx http-ping || true
WORKDIR /dist
RUN cp /build/http-ping /dist/http-ping

FROM scratch
COPY --from=build-layer /dist/ /
USER 50000:50000
EXPOSE 8000
ENTRYPOINT [ "/http-ping" ]
