locals {
  step-run-a-job = {
    "Run a job on EKS" = {
      "Type"     = "Task"
      "Resource" = "arn:${data.aws_partition.current.partition}:states:::eks:runJob.sync"
      "Parameters" = {
        "ClusterName"            = var.cluster
        "CertificateAuthority.$" = "$.eks.Cluster.CertificateAuthority.Data"
        "Endpoint.$"             = "$.eks.Cluster.Endpoint"
        "LogOptions" = {
          "RetrieveLogs" = true
        }
        "Job" = {
          "apiVersion" = "batch/v1"
          "kind"       = "Job"
          "metadata" = {
            "name" = "example-job"
          }
          "spec" = {
            "backoffLimit" = 0
            "template" = {
              "metadata" = {
                "name" = "example-job"
              }
              "spec" = {
                "containers" = [{
                  "name"    = "pi-20"
                  "image"   = "perl"
                  "command" = ["perl"]
                  "args"    = ["-Mbignum=bpi", "-wle", "print '{ ' . '\"pi\": '. bpi(20) . ' }';"]
                }]
                "restartPolicy" = "Never"
              }
            }
          }
        }
      }
      "ResultSelector" = {
        "status.$" = "$.status"
        "logs.$"   = "$.logs..pi"
      }
      "ResultPath" = "$.RunJobResult"
      "Next"       = "Examine output"
    }
  }
}
