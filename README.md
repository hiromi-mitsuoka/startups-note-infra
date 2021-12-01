# startups-note-infra

## 初回セットアップ手順

1. ECS（service, task_definition）はコメントアウトし、ECR までを APPLY する
2. ECR に docker イメージを push

```
# ログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com

# nginx
cd ../startups/nginx
docker build -f Dockerfile . -t startups-note-nginx
docker tag startups-note-nginx:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-nginx:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-nginx:latest

# app
cd ../startups
docker build -f ./terraform/ecs/Dockerfile . -t startups-note-app
docker tag startups-note-app:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-app:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-app:latest
```

3. ECS をコメントインし APPLY

- ログの確認

```
aws logs filter-log-events --log-group-name /ecs/startups-note
```
