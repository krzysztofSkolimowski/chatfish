FROM golang:1.26 AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN go build -o chatfish .

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=builder /app/chatfish .

EXPOSE 8080
CMD ["./chatfish"]
