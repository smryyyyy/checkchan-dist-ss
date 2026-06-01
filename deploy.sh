#!/bin/bash
# CheckChan 自动部署脚本
# 用法: bash deploy.sh
# 首次部署前先修改 docker-compose.yml 里的 WEBHOOK_URL

set -e

echo "📦 启动容器..."
docker-compose up -d

echo "⏳ 等待容器就绪..."
sleep 5

# 检查容器是否正常运行
if ! docker ps --format '{{.Names}}' | grep -q 'check-chrome-1'; then
    echo "❌ 容器启动失败，请检查日志: docker logs check-chrome-1"
    exit 1
fi

echo "📋 注入飞书 Webhook 支持文件..."
docker cp docker/api/func.js check-chrome-1:/checkchan/api/func.js
docker cp docker/api/cron.js check-chrome-1:/checkchan/api/cron.js

echo "🔄 重启容器..."
docker restart check-chrome-1

echo ""
echo "✅ 部署完成！"
echo "   API: http://服务器IP:8088/"
echo "   Web: http://服务器IP:8080/ (VNC=OFF 时不可用)"
echo ""
echo "首次使用请在浏览器插件设置:"
echo "   服务器地址: http://服务器IP:8088/"
echo "   API Key: aPiKe1"
