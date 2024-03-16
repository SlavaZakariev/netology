### cloud vars

variable "token" {
  type    = string
  default = "y0_____"
  # https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type    = string
  default = "b1gq_____"
  # https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type    = string
  default = "b1gr_____"
  # https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id
}

### cloud net

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  # https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  # https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### vm_resources

variable "vms_resources" {
  type        = map(map(number))
  default     = {
    vm_count_resources = {
      cores          = 2
      memory         = 1
      core_fraction  = 5
    }
    vm_disks_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
  }
}

variable "vm_ubuntu_ver" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_cpu_id" {
  type        = string
  default     = "standard-v1"
  description = "cpu id"
  }
