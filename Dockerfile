# 基于官方最新镜像
FROM ghcr.io/router-for-me/cli-proxy-api:v8.0.53

# 将你 GitHub 仓库里的 config.yaml 复制到容器内的指定工作目录
COPY config.yaml /CLIProxyAPI/config.yaml

# 暴露端口
EXPOSE 8317
