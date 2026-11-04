# 固定官方 v8 版本；更新时同步修改 docker-publish.yml 中的版本标签
FROM ghcr.io/router-for-me/cli-proxy-api:v8.0.53

# 将你 GitHub 仓库里的 config.yaml 复制到容器内的指定工作目录
COPY config.yaml /CLIProxyAPI/config.yaml

# 暴露端口
EXPOSE 8317
