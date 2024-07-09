FROM golang:1.22-alpine

WORKDIR /app


COPY . .

RUN go install github.com/air-verse/air@latest
RUN go install github.com/swaggo/swag/cmd/swag@latest

COPY go.mod go.sum ./
RUN go mod download

# Ensure the application uses the correct DB_URL
CMD ["sh", "-c", "DB_URL=$DB_URL swag init --parseDependency --parseInternal && air -c .air.toml"]
