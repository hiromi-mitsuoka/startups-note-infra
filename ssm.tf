# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
# # 平文
# resource "aws_ssm_parameter" "db_username" {
#   name = "/db/password"
#   value = "startups"
#   type = "String"
# }

# # 暗号化
# resource "aws_ssm_parameter" "db_password" {
#   name = "/db/password"
#   value = "uninitialized" # 暗号化する値がソースコードに平文で書かれてしまう
#   type = "SecureString"
#   description = "Database password"

#   lifecycle {
#     ignore_changes = [value]
#   }

#   # apply後
#   # $ aws ssm put-parameter --name '/db/password' --type SecureString --value '〇〇' --overwrite
# }