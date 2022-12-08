data "aws_partition" "current" {}

data "aws_vpc" "cluster_vpc" {
  tags = {
    Name = var.network
  }
}

data "aws_subnets" "cluster_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cluster_vpc.id]
  }

  dynamic "filter" {
    for_each = length(var.availability_zones) > 0 ? zipmap(range(0,
    length(var.availability_zones)), var.availability_zones) : {}

    content {
      name   = "availability-zone"
      values = var.availability_zones
    }
  }

  tags = {
    Tier = var.tier
  }
}
