# startups-note-infra

## 初回セットアップ手順

1. ECS（service, task_definition）はコメントアウトし、ECR までを APPLY する
2. DB の password 変更
   **"aws rds modify-db-instance --db-instance-identifier 'startups-note' --master-user-password '〇〇'"**
3. ECR に docker イメージを push

```
# ログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com

# nginx
pwd => startups-note/startups/nginx
docker build -f Dockerfile . -t startups-note-nginx
docker tag startups-note-nginx:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-nginx:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-nginx:latest

# app
pwd => startups-note/startups
# 他のdockerは止める
docker build -f ../infra/Dockerfile . -t startups-note-app
docker tag startups-note-app:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-app:latest
docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/startups-note-app:latest
```

4. ECS をコメントインし APPLY

## ログの確認

```
# ECS
aws logs filter-log-events --log-group-name /ecs/startups-note
```

## メモ

```
error creating ELBv2 Listener (arn:aws:elasticloadbalancing:ap-northeast-1:<アカウントID>:loadbalancer/app/startups-note-alb/~~~~): UnsupportedCertificate: The certificate 'arn:aws:acm:ap-northeast-1:<アカウントID>:certificate/~~~~' must have a fully-qualified domain name, a supported signature, and a supported key size.
```

↑ apply 時に、SSL 証明書の検証が終わらずにエラー、再度 apply すると成功。

```
denied: User: arn:aws:iam::<別アカウントID>:user/~~ is not authorized to perform: ecr:InitiateLayerUpload on resource: arn:aws:ecr:ap-northeast-1:<アカウントID>:repository/startups-note-app because no resource-based policy allows the ecr:InitiateLayerUpload action
```

↑ アカウント設定が反映されていない or ログアウトしている

```
# アカウント設定方法
export AWS_DEFAULT_PROFILE=ユーザー名
aws configure list

+

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com
```
