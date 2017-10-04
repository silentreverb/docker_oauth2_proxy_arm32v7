FROM arm32v7/golang:1.8.3 as builder
RUN wget https://raw.githubusercontent.com/pote/gpm/v1.4.0/bin/gpm && chmod +x gpm && mv gpm /usr/local/bin
RUN mkdir -p /go/src/github.com/bitly/ && \
    cd /go/src/github.com/bitly && \
    git clone https://github.com/bitly/oauth2_proxy.git && \
    cd oauth2_proxy && \
    git checkout v2.2
COPY dist.sh /go/src/github.com/bitly/oauth2_proxy/dist.sh
RUN cd /go/src/github.com/bitly/oauth2_proxy/ && ./dist.sh

FROM arm32v6/alpine:3.6 as base
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/bin/oauth2_proxy .
EXPOSE 4180/tcp
CMD ["./oauth2_proxy"]
