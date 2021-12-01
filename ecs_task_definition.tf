# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "startups_note" {
  family = "startups-note"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc" # Fargate起動タイプ
  requires_compatibilities = ["FARGATE"]

  # CloudWatch Logsにログを投げるためのロール
  execution_role_arn = module.startups_note_ecs_task_execution_role.iam_role_arn

  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
  container_definitions = jsonencode([
    {
      name = "startups-note-nginx"
      # Note : URLを直接入力しないで反映
      image = "${aws_ecr_repository.startups_note_nginx.repository_url}:latest"
      logConfiguration: {
        logDriver: "awslogs",
        secretOptions: null,
        options: {
          awslogs-group: "/ecs/startups-note",
          awslogs-region: "ap-northeast-1",
          awslogs-stream-prefix: "nginx"
        }
      },
      portMappings: [
        {
          protocol: "tcp",
          containerPort: 80
        }
      ],
      workingDirectory: "/startups-note",
      # volumesFrom: [
      #   {
      #     sourceContainer: "startups-note-app",
      #     readOnly: false
      #   }
      # ],
      essential: true # タスク実行に必要かどうか
    }
  ])
}