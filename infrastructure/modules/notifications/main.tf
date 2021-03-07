data "template_file" "cloudformation-sns-stack" {
  template = file("${path.module}/templates/email-sns-stack.json.tpl")

  vars = {
    DISPLAY_NAME = "${var.APP_NAME}-${var.ENV}-bot"
    SUBSCRIPTIONS = join(
      ",",
      formatlist(
        "{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\"  }",
        var.SNS_EMAIL_ADDRESSES,
        var.SNS_PROTOCOL
      )
    )
  }
}

resource "aws_cloudformation_stack" "sns-topic" {
  name          = "${var.APP_NAME}-${var.ENV}-${var.SNS_STACK_NAME}"
  template_body = data.template_file.cloudformation-sns-stack.rendered
  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-${var.SNS_STACK_NAME}"
  }
}
