
FROM golang:1.22-alpine AS build
RUN apk --no-cache add gcc g++ make git
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/web-app ./main.go


FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
WORKDIR /root/
COPY --from=builder /app/app .

EXPOSE 80
ENTRYPOINT /go/bin/web-app --port 80
