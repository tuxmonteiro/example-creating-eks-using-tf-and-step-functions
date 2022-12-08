variable "cluster" {
  type    = string
  default = "make-by-sf"
}

variable "nodegroup" {
  type    = string
  default = "ng01"
}

variable "network" {
  type = string
  default = "management"
}

variable "tier" {
  type = string
  default = "private"
}

variable "availability_zones" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1f"
  ]
}
