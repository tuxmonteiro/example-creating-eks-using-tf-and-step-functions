locals {
  step-send-expected-result = {
      "Send expected result" = {
        "Type"     = "Task"
        "Resource" = "arn:${data.aws_partition.current.partition}:states:::sns:publish"
        "Parameters" = {
          "TopicArn" = aws_sns_topic.sns_topic.id
          "Message" = {
            "Input.$" = "States.Format('Saw expected value for pi: {}', $.RunJobResult.logs[0])"
          }
        }
        "ResultPath" = "$.SNSResult"
        "Next"       = "Delete job"
      }
  }
}
