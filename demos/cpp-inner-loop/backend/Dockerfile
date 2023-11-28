FROM alpine:3.18 AS build
RUN apk update
RUN apk add linux-headers musl-dev build-base
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN gcc -o /app/hello ./main.c
RUN chmod 755 /app/hello

FROM alpine:3.18 AS app
COPY --from=build /app/hello /hello
USER nobody
ENTRYPOINT [ "/hello" ]
