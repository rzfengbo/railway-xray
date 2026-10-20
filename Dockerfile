FROM alpine:3.20

# Xray-core 官方 release（构建时下载，无需自己编译）
RUN apk add --no-cache ca-certificates curl unzip tzdata \
 && curl -fsSL -o /tmp/xray.zip \
      https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && mkdir -p /usr/local/share/xray \
 && unzip -q /tmp/xray.zip -d /usr/local/share/xray \
 && mv /usr/local/share/xray/xray /usr/local/bin/xray \
 && chmod +x /usr/local/bin/xray \
 && rm -f /tmp/xray.zip

ENV XRAY_LOCATION_ASSET=/usr/local/share/xray

COPY config.template.json /etc/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Railway 会注入 PORT，容器必须监听 0.0.0.0:$PORT
EXPOSE 8080
CMD ["/entrypoint.sh"]
