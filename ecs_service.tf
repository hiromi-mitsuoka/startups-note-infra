# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition
data "aws_ecs_task_definition" "startups_note" {
  task_definition = aws_ecs_task_definition.startups_note.family
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "startups_note" {
  name = "startups-note"
  cluster = aws_ecs_cluster.startups_note.id

  # タスクの自動更新
  # max: https://www.terraform.io/docs/language/functions/max.html
  task_definition = "${aws_ecs_task_definition.startups_note.family}:${max(aws_ecs_task_definition.startups_note.revision, data.aws_ecs_task_definition.startups_note.revision)}"

  desired_count = 2 # 維持するタスク数 # TODO: nginx, appが2つずつで合っているか確認
  deployment_minimum_healthy_percent = 100 # desired_countに対する最小タスク数（%）
  deployment_maximum_percent = 200 # desired_countに対する最大タスク数（%）
  launch_type = "FARGATE"
  platform_version = "1.3.0" # デフォルトのLATESTは非推奨
  health_check_grace_period_seconds = 60 # タスク起動時のヘルスチェック猶予期間、デフォルト0sのため設定
  scheduling_strategy = "REPLICA" # Defaults to REPLICA

  network_configuration {
    subnets = [
      aws_subnet.private_1a.id,
      aws_subnet.private_1c.id,
    ]

    security_groups = [
      module.http_sg.security_group_id,
      module.https_sg.security_group_id # esも443
      # module.inbound_traffic_sg.security_group_id
      # Note: module.db_sg.security_group_id は必要かどうか
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.startups_note.arn
    container_name = "startups-note-nginx"
    container_port = 80
  }

  # # Fargateの場合、デプロイのたびにタスク定義が更新され、plan時に差分が出るため、リソースの初回作成時を除き変更を無視
  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
}