output "state_machine_arn" {
  value = aws_sfn_state_machine.eks_cluster_management_state_machine.id
}

output "execution_input" {
  description = "Sample input to StartExecution."
  value       = "{}"
}
