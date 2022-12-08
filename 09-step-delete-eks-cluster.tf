locals {
  step-delete-eks-cluster = {
    "Delete cluster" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:deleteCluster.sync"
      "Parameters" = {
        "Name" = var.cluster
      }
      "End" = true
    }
  }
}
