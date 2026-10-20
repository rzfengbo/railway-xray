#!/bin/sh
set -eu

PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ray}"
UUID="${UUID:-}"

# 没配 UUID 时临时生成一个（重启会变，仅用于首次验证，正式使用请写进 Railway 变量）
if [ -z "$UUID" ]; then
  UUID="$(cat /proc/sys/kernel/random/uuid)"
  echo "[entrypoint] WARNING: 未设置 UUID 变量，本次随机生成: $UUID"
  echo "[entrypoint] 请把它加到 Railway Variables，否则每次重启节点都会失效"
fi

# 路径规范化：保证以 / 开头
case "$WS_PATH" in
  /*) ;;
  *) WS_PATH="/$WS_PATH" ;;
esac

sed -e "s|__PORT__|${PORT}|g" \
    -e "s|__UUID__|${UUID}|g" \
    -e "s|__WS_PATH__|${WS_PATH}|g" \
    /etc/xray/config.template.json > /etc/xray/config.json

echo "[entrypoint] xray starting on 0.0.0.0:${PORT}, ws path = ${WS_PATH}"
exec /usr/local/bin/xray -config /etc/xray/config.json
