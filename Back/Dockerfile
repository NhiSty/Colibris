FROM golang:1.22-alpine

WORKDIR /app

RUN go install github.com/air-verse/air@latest
RUN go install github.com/swaggo/swag/cmd/swag@latest

COPY go.mod go.sum ./
RUN go mod download

RUN apk add --no-cache curl

CMD swag init --parseDependency --parseInternal && air -c .air.toml