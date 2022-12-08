locals {
  step-create-nodegroup = {
    "Create a node group" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:createNodegroup.sync"
      "Parameters" = {
        "ClusterName"   = var.cluster
        "NodegroupName" = var.nodegroup
        "NodeRole"      = aws_iam_role.node_instance_role.arn
        "Subnets"       = data.aws_subnets.cluster_subnets.ids
      }
      "Retry" = [{
        "ErrorEquals"     = ["States.ALL"]
        "IntervalSeconds" = 30
        "MaxAttempts"     = 2
        "BackoffRate"     = 2
      }]
      "ResultPath" = "$.nodegroup"
      "Next"       = "Run a job on EKS"
    }
  }
}
