locals {

  step-delete-job = {
    "Delete job" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:call"
      "Parameters" = {
        "ClusterName"            = var.cluster
        "CertificateAuthority.$" = "$.eks.Cluster.CertificateAuthority.Data"
        "Endpoint.$"             = "$.eks.Cluster.Endpoint"
        "Method"                 = "DELETE"
        "Path"                   = "/apis/batch/v1/namespaces/default/jobs/example-job"
      }
      "ResultSelector" = {
        "status.$" = "$.ResponseBody.status"
      }
      "ResultPath" = "$.DeleteJobResult"
      "Next"       = "Delete node group"
    }
  }
}
