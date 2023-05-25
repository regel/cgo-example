ARG BUILD_CONTAINER=golang:1.20
#--- cc image contains a minimal Linux, glibc runtime for "mostly-statically compiled" languages ---#
ARG RUN_CONTAINER=gcr.io/distroless/cc-debian11:nonroot

#--- Build binary in Go container ---#
FROM ${BUILD_CONTAINER} as builder

ARG CGO_ENABLED=1
ARG LDFLAGS="-s -w -X main.version=unknown -X main.commit=unknown -X main.date=unknown -L example.a" 

# Build app
WORKDIR /app
ADD . .

RUN g++ -c -o example.o example.cpp
RUN ar rcs example.a example.o

RUN go mod download
RUN GO111MODULE=on CGO_ENABLED=$CGO_ENABLED go build -a \
  -ldflags "${LDFLAGS}" \
  -o bin .

#--- Build runtime container ---#
FROM ${RUN_CONTAINER}
WORKDIR /
# Copy certs, app, and user
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /app/bin /app/bin

USER 65532:65532

# Run entrypoint
ENTRYPOINT ["/app/bin"]
