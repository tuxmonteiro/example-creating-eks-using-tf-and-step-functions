locals {
  step-create-eks-cluster = {
    "Create an EKS cluster" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:createCluster.sync"
      "Parameters" = {
        "Name" = var.cluster
        "ResourcesVpcConfig" = {
          "SubnetIds" = data.aws_subnets.cluster_subnets.ids
        }
        "RoleArn" = aws_iam_role.eks_service_role.arn
      }
      "Retry" = [{
        "ErrorEquals"     = ["States.ALL"]
        "IntervalSeconds" = 30
        "MaxAttempts"     = 2
        "BackoffRate"     = 2
      }]
      "ResultPath" = "$.eks"
      "Next"       = "Create a node group"
    }
  }
}
