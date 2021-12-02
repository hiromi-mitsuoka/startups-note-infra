module "startups_note_describe_regions_for_ec2" {
  source = "./modules/iam_role"
  name = "startups-note-describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    actions = ["ec2:DescribeRegions"] # リージョン一覧を取得
    resources = ["*"]
    effect = "Allow"
  }
}


# ECS

module "startups_note_ecs_task_execution_role" {
  source = "./modules/iam_role"
  name = "startups-note-ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com" # このIAMロールをECSで使用することを宣言
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}

# ECSタスク実行IAMロール
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  # AWSが管理するポリシー、CloudWatch Logs, ECRの操作権限を持つ
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク実行IAMロールのポリシードキュメント定義
data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy # 既存のポリシーを継承

  statement {
    effect = "Allow"
    actions = ["ssm:GetParamters", "kms:Decrypt"]
    resources = ["*"]
  }
}
