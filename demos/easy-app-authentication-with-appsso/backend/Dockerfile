FROM golang:1.21-alpine AS base
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN mkdir /work
COPY main.go go.mod go.sum /work
WORKDIR /work
RUN go build -o /tmp/backend -ldflags "-s -w"

FROM scratch AS app
COPY --from=base /tmp/backend /backend
ENTRYPOINT [ "/backend" ]
