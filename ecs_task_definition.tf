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
      workingDirectory: "/startups", # Gemfile, startupsディレクトリに合わせる
      volumesFrom: [
        {
          sourceContainer: "startups-note-app",
          readOnly: false
        }
      ],
      essential: true # タスク実行に必要かどうか
    },
    {
      name: "startups-note-app"
      image = "${aws_ecr_repository.startups_note_app.repository_url}:latest"
      logConfiguration: {
        logDriver: "awslogs",
        options: {
          awslogs-group: "/ecs/startups-note",
          awslogs-region: "ap-northeast-1",
          awslogs-stream-prefix: "app"
        }
      },
      environment: [
        {
          name: "DATABASE_HOST",
          value: var.db_endpoint
        },
        {
          name: "DATABASE_NAME",
          value: var.db_name
        },
        {
          name: "DATABASE_PASSWORD",
          value: var.db_password
        },
        {
          name: "DATABASE_USERNAME",
          value: var.db_username
        },
        {
          name: "RAILS_ENV",
          value: var.db_rails_env
        },
        {
          name: "RAILS_MASTER_KEY",
          value: var.master_key
        },
        {
          name: "TZ",
          value: "Japan"
        }
      ],
      command: [
        "bash",
        "-c",
        "bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rails assets:precompile && bundle exec puma -C config/puma.rb"
      ],
      workingDirectory: "/startups",  # Gemfile, startupsディレクトリに合わせる
      essential: true
    }
  ])
}


# Not comment out to deploy. (on cloud_watch.tf line 48, in resource "aws_cloudwatch_event_target" "rss_batch":)
# ECS Scheduled Tasks (RSS)
resource "aws_ecs_task_definition" "rss_batch" {
  family = "startups-note-rss-batch"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # Use the iam_role created earlier.
  execution_role_arn = module.startups_note_ecs_task_execution_role.iam_role_arn

  # the image is alpine
  container_definitions = jsonencode([
    {
      name = "alpine"
      image = "alpine:latest"
      essential: true
      logConfiguration: {
        logDriver: "awslogs"
        options: {
          awslogs-group: "/ecs-scheduled-tasks/rss-batch",
          awslogs-region: "ap-northeast-1",
          awslogs-stream-prefix: "rss-batch"
        }
      },
      command: [
        "bash",
        "-c",
        "bundle exec rake article:get_articles_count_used_categories"
      ],
    }
  ])
}