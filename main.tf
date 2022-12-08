resource "aws_sfn_state_machine" "eks_cluster_management_state_machine" {
  role_arn   = aws_iam_role.eks_cluster_management_state_machine_execution_role.arn
  definition = jsonencode({
    "StartAt" = "Create an EKS cluster"
    "States" = merge(
      local.step-create-eks-cluster,
      local.step-create-nodegroup,
      local.step-run-a-job,
      local.step-examine-output,
      local.step-send-expected-result,
      local.step-send-unexpected-result,
      local.step-delete-job,
      local.step-delete-nodegroup,
      local.step-delete-eks-cluster
    )
  })
}

resource "aws_iam_policy" "states_execution_policy" {
  name = "StatesExecutionPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*",
          "ec2:DescribeSubnets",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Resource = "*"
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = [
              "eks*.amazonaws.com"
            ]
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.sns_topic.id
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          aws_iam_role.eks_service_role.arn,
          aws_iam_role.node_instance_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "eks_cluster_management_state_machine_execution_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  path                  = "/"
  force_detach_policies = true
  managed_policy_arns   = [aws_iam_policy.states_execution_policy.arn]
}

resource "aws_iam_role" "node_instance_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.${data.aws_partition.current.dns_suffix}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_iam_role" "eks_service_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "aws_sns_topic" "sns_topic" {
  kms_master_key_id = "alias/aws/sns"
}
