locals {
  step-delete-nodegroup = {
    "Delete node group" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:deleteNodegroup.sync"
      "Parameters" = {
        "ClusterName"   = var.cluster
        "NodegroupName" = var.nodegroup
      }
      "Next" = "Delete cluster"
    }
  }
}
