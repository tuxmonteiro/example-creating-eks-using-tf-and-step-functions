locals {
  step-send-unexpected-result = {
    "Send unexpected result" = {
        "Type"     = "Task"
        "Resource" = "arn:${data.aws_partition.current.partition}:states:::sns:publish"
        "Parameters" = {
          "TopicArn" = aws_sns_topic.sns_topic.id
          "Message" = {
            "Input.$" = "States.Format('Saw unexpected value for pi: {}', $.RunJobResult.logs[0])"
          }
        }
        "ResultPath" = "$.SNSResult"
        "Next"       = "Delete job"
      }
  }
}
