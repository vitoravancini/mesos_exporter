FROM alpine:3.4

EXPOSE 9110

RUN addgroup exporter \
 && adduser -S -G exporter exporter

COPY . /usr/local/go/src/github.com/vitoravancini/mesos_exporter

RUN apk --update add ca-certificates \
 && apk --update add --virtual build-deps go git

RUN  cd /usr/local/go/src/github.com/vitoravancini/mesos_exporter && GOPATH=/usr/local/go/ go get github.com/prometheus/client_golang/prometheus 
RUN  cd /usr/local/go/src/github.com/prometheus/client_golang/prometheus && git checkout tags/v0.8.0  

RUN  cd /usr/local/go/src/github.com/vitoravancini/mesos_exporter && GOPATH=/usr/local/go/ go get 
RUN  cd /usr/local/go/src/github.com/vitoravancini/mesos_exporter && GOPATH=/usr/local/go/ go build -o /bin/mesos-exporter

RUN apk del --purge build-deps \
 && rm -rf /go/bin /go/pkg /var/cache/apk/*

USER exporter

ENTRYPOINT [ "/bin/mesos-exporter" ]

