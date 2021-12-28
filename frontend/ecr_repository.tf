# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
resource "aws_ecr_repository" "front_nginx" {
  name = "startups-note-front-nginx" # TODO: match the tag to the docker image.
  image_tag_mutability = "MUTABLE"

  # https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/image-scanning.html
  image_scanning_configuration {
    scan_on_push = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy
resource "aws_ecr_lifecycle_policy" "front_nginx" {
  repository = aws_ecr_repository.front_nginx.name

  policy = jsonencode(
    {
      "rules": [
        {
          "rulePriority": 1,
          "description": "Keep last 3 imgages"
          "selection": {
            "tagStatus": "any",
            "countType": "imageCountMoreThan",
            "countNumber": 3
          },
          "action": {
            "type": "expire"
          }
        }
      ]
    }
  )
}

resource "aws_ecr_repository" "front_nextjs" {
  name = "startups-note-front-nextjs" # TODO: match the tag to the docker image.
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "front_nextjs" {
  repository = aws_ecr_repository.front_nextjs.name

  policy = jsonencode(
    {
      "rules": [
        {
          "rulePriority": 1,
          "description": "Keep last 3 imgages"
          "selection": {
            "tagStatus": "any",
            "countType": "imageCountMoreThan",
            "countNumber": 3
          },
          "action": {
            "type": "expire"
          }
        }
      ]
    }
  )
}
