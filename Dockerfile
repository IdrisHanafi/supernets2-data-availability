# CONTAINER FOR BUILDING BINARY
FROM golang:1.19 AS build

# INSTALL DEPENDENCIES
RUN go install github.com/gobuffalo/packr/v2/packr2@v2.8.3
COPY go.mod go.sum /src/
RUN cd /src && go mod download

# BUILD BINARY
COPY . /src
RUN cd /src/db && packr2
RUN cd /src && make build

# CONTAINER FOR RUNNING BINARY
FROM alpine:3.16.0
COPY --from=build /src/dist/supernets2-data-availability /app/supernets2-data-availability
EXPOSE 8444
CMD ["/bin/sh", "-c", "/app/supernets2-data-availability run"]
