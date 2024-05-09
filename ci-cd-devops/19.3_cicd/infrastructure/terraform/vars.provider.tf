### cloud vars
variable "token" {
  type    = string
  default = "y0_*****"
  # https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type    = string
  default = "b1*****"
  # https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type    = string
  default = "b1*****"
  # https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id
}

### cloud net
variable "zone_a" {
  type    = string
  default = "ru-central1-a"
  # https://cloud.yandex.ru/docs/overview/concepts/geo-scope
}

variable "cidr_a" {
  type    = list(string)
  default = ["10.10.10.0/24"]
  # https://cloud.yandex.ru/docs/vpc/operations/subnet-create
}

variable "vpc_name" {
  type        = string
  default     = "vpc_ci-cd"
  description = "VPC network for CI-CD VMs"
}

variable "subnet_name" {
  type        = string
  default     = "subnet_ci-cd"
  description = "Subnet name for CI-CD VMs"
}
