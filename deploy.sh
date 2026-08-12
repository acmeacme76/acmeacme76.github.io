#!/usr/bin/env bash
# 把本目录的静态网站内容同步到 nh.acmeacme.net (129.150.45.122)
# 用法: ./deploy.sh [--dry-run]

set -euo pipefail

SSH_KEY="$HOME/.ssh/ssh-key-oracle-nh.key"
REMOTE_HOST="ubuntu@129.150.45.122"
REMOTE_DIR="/var/www/nh.acmeacme.net/"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

RSYNC_OPTS=(-avz --delete
  --exclude='.git'
  --exclude='.gitignore'
  --exclude='README.md'
  --exclude='.DS_Store'
  --exclude='deploy.sh'
  --exclude='Makefile'
  -e "ssh -i $SSH_KEY")

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  RSYNC_OPTS+=(--dry-run)
  DRY_RUN=1
  echo "== 预览模式，不会真正修改服务器 =="
fi

rsync "${RSYNC_OPTS[@]}" "$LOCAL_DIR" "$REMOTE_HOST:$REMOTE_DIR"

if [[ "$DRY_RUN" == "0" ]]; then
  ssh -i "$SSH_KEY" "$REMOTE_HOST" \
    "sudo find $REMOTE_DIR -type d -exec chmod 755 {} \; && sudo find $REMOTE_DIR -type f -exec chmod 644 {} \; && sudo chgrp -R www-data $REMOTE_DIR"
  echo "部署完成: https://nh.acmeacme.net/"
fi
