# 使用国内镜像源替代官方golang镜像
FROM golang:1.24-alpine AS builder

WORKDIR /app


# 预下载依赖（利用缓存）
COPY go.mod go.sum ./
RUN go mod download

# 复制源码并构建
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/main

# 最终阶段使用scratch空镜像
FROM scratch
WORKDIR /app

# 复制可执行文件
COPY --from=builder /app/main /app/main

# 使用非root用户运行
USER 1000

# 启动应用
ENTRYPOINT ["/app/main"]
