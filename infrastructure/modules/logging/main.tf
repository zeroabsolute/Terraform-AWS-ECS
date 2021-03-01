resource "aws_cloudwatch_log_group" "cloudwatch-group" {
  name = "${var.APP_NAME}-${var.ENV}-log-group"

  tags = {
    Environment = "${var.ENV}"
    Application = "${var.APP_NAME}"
  }
}
