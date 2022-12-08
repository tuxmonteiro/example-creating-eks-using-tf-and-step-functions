locals {
  cron_time = formatdate("mm hh DD MM ? YYYY", timeadd(timestamp(), "2m"))
}

module "eventbridge" {
  source = "./modules/eventbridge"

  create_bus = false

  rules = {
    crons = {
      description         = "Run state machine"
      #schedule_expression = "at(yyyy-mm-ddThh:mm:ss)" NOT WORK. Provider version?
      schedule_expression = "cron(${local.cron_time})"
    }
  }

  targets = {
    crons = [
      {
        name            = "create-eks-cluster_${var.cluster}"
        arn             = aws_sfn_state_machine.eks_cluster_management_state_machine.arn
        attach_role_arn = true
      }
    ]
  }

  sfn_target_arns   = [aws_sfn_state_machine.eks_cluster_management_state_machine.arn]
  attach_sfn_policy = true
}

