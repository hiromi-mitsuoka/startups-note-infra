# ALBがリクエストをフォワードする対象
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "startups_note" {
  name = "startups-note"
  target_type = "ip" # ECS Fargate の場合、ip
  vpc_id = aws_vpc.main.id
  port = 80
  protocol = "HTTP"
  deregistration_delay = 300

  health_check {
    path = "/"
    healthy_threshold = 5 # 正常判定を行うまでのヘルスチェック実行回数
    unhealthy_threshold = 2 # 異常判定を行うまでのヘルスチェック実行回数
    timeout = 5 # ヘルスチェックのタイムアウト時間
    interval = 30 # ヘルスチェックの実行間隔
    matcher = 200 # 正常判定を行うために使用するHTTPステータスコード
    port = "traffic-port" # ヘルスチェック時に使用するプロトコル。「traffic-port」⇨ 指定したportを使用
    protocol = "HTTP"
  }

  # 同時作成時にエラーになるため、依存関係を制御するワークアラウンド（応急措置）を追加
  depends_on = [aws_lb.startups_note_alb]
}