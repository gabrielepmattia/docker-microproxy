FROM golang:1.19.2-buster as build
LABEL stage=builder

# WORKDIR /go
# COPY . .

# build
ENV CGO_ENABLED=1

WORKDIR /go/src/

RUN git clone https://github.com/thekvs/microproxy

WORKDIR /go/src/microproxy
RUN go build -v

FROM debian:10-slim

LABEL org.label-schema.license="GPLv3" \
    org.label-schema.vcs-type="git" \
    org.label-schema.name="gabrielepmattia/microproxy" \
    org.label-schema.vendor="gabrielepmattia" \
    org.label-schema.docker.schema-version="1.0"

WORKDIR /home/app
COPY --from=build /go/src/microproxy/microproxy .

COPY microproxy.toml .
COPY auth.txt .

# set permissions
# RUN addgroup -S app && adduser -S -g app app
# RUN chown -R app:app ./
# USER app

EXPOSE 3128

CMD ["./microproxy"]