# # KMS: エンベロープ暗号化、カスタマーマスターキーが自動生成したデータキーを使用して、暗号化と複号を行う

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
# resource "aws_kms_key" "startups_note" {
#   description = "Customer Master Key"
#   enable_key_rotation = true # 頻度は年に一度、ローテーション後も複号に必要な古い暗号化マテリアルは保存
#   is_enabled = true # カスタマーマスターキーの有効化
#   deletion_window_in_days = 7
#   # 削除待機期間、削除したカスタマーマスターキーで暗号化したデータは、いかなる手段でも複号できなくなる
# }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
# resource "aws_kms_alias" "startups_note" {
#   name = "alias/startups-note"
#   target_key_id = aws_kms_key.startups_note.key_id
# }