FROM golang:1.10-alpine3.9 AS build

RUN apk add --no-cache git make upx
RUN go get github.com/mrtazz/checkmake

RUN wget -qO- https://github.com/jgm/pandoc/releases/download/2.7.1/pandoc-2.7.1-linux.tar.gz | tar -xvz
RUN cp pandoc-2.7.1/bin/pandoc /usr/local/bin/

WORKDIR /go/src/github.com/mrtazz/checkmake

RUN make
RUN upx --best --ultra-brute /go/bin/checkmake

FROM alpine as binary

COPY --from=build /go/bin/checkmake /opt/checkmake/checkmake

RUN mkdir -p /opt/checkmake/src
WORKDIR /opt/checkmake/src/

ENTRYPOINT ["/opt/checkmake/checkmake"]
