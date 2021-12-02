# MySQLのmy.cnfファイルに定義する設定をDBパラメータグループで記述
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "startups_note" {
  name = "startups-note"
  family = "mysql8.0" # エンジン名とバージョン指定、docker-compose.ymlに揃えた

  parameter {
    name = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_server"
    value = "utf8mb4"
  }
}

# データベースエンジンにオプション機能を追加するDBオプショングループ
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
resource "aws_db_option_group" "startups_note" {
  name = "startups-note"
  engine_name = "mysql"
  major_engine_version = "8.0"

  option {
    # MariaDB監査プラグイン : ユーザーのログオンや実行したクエリなどの、アクティビティを記録するプラグイン
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "startups_note" {
  name = "startups-note-db-subnet"
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "startups_note" {
  identifier = "startups" # DBエンドポイントで使う識別子設定、初期の設定を引き継ぎ、「startups」のまま
  engine = "mysql"
  engine_version = "8.0.25" # NOTE: うまく起動しない時、（パッチ）バージョンを疑う
  instance_class = "db.t2.micro"
  allocated_storage = 10 # NOTE: できる限り小さく
  max_allocated_storage = 50 # ストレージ枯渇を避けるために容量を自動的にスケール、CHECK: 小さめにした
  storage_type = "gp2" # 汎用SSD

  # TODO: KMS追加時にコメントイン
  # storage_encrypted = true # ディスク暗号化
  # kms_key_id = aws_kms_key.startups.arn

  username = var.db_username
  password = "dummypassword"
  multi_az = true
  publicly_accessible = false # VPC外からのアクセスを遮断
  backup_window = "09:10-09:40" # 毎日のバックアップのタイミング設定、UTC
  backup_retention_period = 10 # バックアップ期間、最大30日
  maintenance_window = "mon:10:10-mon:10:40" # UTC
  auto_minor_version_upgrade = false # 自動マイナーバージョンアップ無効化

  deletion_protection = false # 削除保護, TODO: 運用時はtrueに
  skip_final_snapshot = true # インスタンス削除時のスナップショット, TODO: 運用時は変更

  port = 3306
  apply_immediately = false # 設定変更の即時反映をやめ、ダウンタイムの発生を避ける
  vpc_security_group_ids = [module.mysql_sg.security_group_id]
  parameter_group_name = aws_db_parameter_group.startups_note.name
  option_group_name = aws_db_option_group.startups_note.name
  db_subnet_group_name = aws_db_subnet_group.startups_note.name

  lifecycle {
    ignore_changes = [password]
  }
}

# NOTE: マスターパスワードの変更
# aws_db_instanceリソースのpasswordは必須項目で省略できないが、パスワードがtfstateファイルに、平文で書き込まれる
# varitableでtfファイルでの平文を回避しても、tfstateファイルへの書き込みは回避できないため、
# ignore_changes = [password]を指定してapplyした後に、マスターパスワードを変更

# 変更方法
# aws rds modify-db-instance --db-instance-identifier 'startups' --master-user-password '〇〇'


# ElastiCache : Redis使用, クラスタモード無効