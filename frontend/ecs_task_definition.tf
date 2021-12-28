# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "front" {
  family = "startups-note-front"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # TODO: Make CloudWatch Logs
  execution_role_arn = module.front_ecs_task_execution_role.iam_role_arn

  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
  container_definitions = jsonencode([
    {
      name = "front-nginx"
      image = "${aws_ecr_repository.front_nginx.repository_url}:latest"
      logConfiguration: {
        logDriver: "awslogs",
        secretOptions: null,
        options: {
          awslogs-group: "/ecs/startups-note-front",
          awslogs-region: "ap-northeast-1",
          awslogs-stream-prefix: "nginx"
        }
      },
      portMappings: [
        {
          protocol: "tcp",
          containerPort: 81 # NOTE
        }
      ],
      workingDirectory: "/usr/src/app"
      volumesFrom: [
        {
          sourceContainer: "front-nextjs",
          readOnly: false
        }
      ],
      essential: true
    },
    {
      name = "front-nextjs"
      image = "${aws_ecr_repository.front_nextjs.repository_url}:latest"
      logConfiguration: {
        logDriver: "awslogs",
        secretOptions: null,
        options: {
          awslogs-group: "/ecs/startups-note-front",
          awslogs-region: "ap-northeast-1",
          awslogs-stream-prefix: "nextjs"
        }
      },
      portMappings: [
        {
          containerPort: 3333
        }
      ],
      command: [
        "yarn", "start"
      ],
      environment: [
        {
          name: "NODE_ENV",
          value: "production"
        },
        {
          name: "TZ",
          value: "Japan"
        }
      ],
      workingDirectory: "/usr/src/app"
      essential: true
    }
  ])
}