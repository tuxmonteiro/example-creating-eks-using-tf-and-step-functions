output "state_machine_arn" {
  value = aws_sfn_state_machine.eks_cluster_management_state_machine.id
}
