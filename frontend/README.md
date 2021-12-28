# startups-note-front

## 初回セットアップ手順

1. `aws configure list`で profile 確認

2. ECS（service, task_definition）はコメントアウトし、ECR までを APPLY する

3. ECR に docker イメージを push

```
# ログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com

# nginx
pwd => startups-note/frontend/nginx
docker build -f Dockerfile . -t startups-note-front-nginx
docker tag startups-note-front-nginx:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-front-nginx:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-front-nginx:latest

# nextjs
pwd => startups-note/frontend
# 他のdockerは止める
docker build -f ../infra/frontend/Dockerfile . -t startups-note-front-nextjs (--no-cache)
docker tag startups-note-front-nextjs:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-front-nextjs:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-front-nextjs:latest
```

4. ECS をコメントインし APPLY

## ログ確認

```
# ECS
aws logs filter-log-events --log-group-name /ecs/startups-note-front
```
