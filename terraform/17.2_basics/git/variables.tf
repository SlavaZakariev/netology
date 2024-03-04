### cloud vars

variable "token" {
  type    = string
  default = "y0________"
  # https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type    = string
  default = "b1gq_______"
  # https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type    = string
  default = "b1gr_______"
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
  default = ["10.10.1.0/24"]
  # https://cloud.yandex.ru/docs/vpc/operations/subnet-create
}

variable "vpc_nameweb" {
  type        = string
  default     = "web"
  description = "VPC network for web"
}

variable "subnet_nameweb" {
  type        = string
  default     = "web_subnet"
  description = "Subnet name for web VMs"
}

variable "zone_b" {
  type    = string
  default = "ru-central1-b"
}

variable "cidr_b" {
  type    = list(string)
  default = ["10.10.2.0/24"]
}

variable "vpc_namedb" {
  type        = string
  default     = "db"
  description = "VPC network for db"
}

variable "subnet_namedb" {
  type        = string
  default     = "db_subnet"
  description = "Subnet name for db VMs"
}

### vm_resources

variable "vms_resources" {
  type        = map(map(number))
  default     = {
    vm_web_resources = {
      cores          = 2
      memory         = 1
      core_fraction  = 5
    }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vm_web_version" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_web_cpu_id" {
  type        = string
  default     = "standard-v1"
  description = "cpu id"
}

variable "vm_db_version" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_db_cpu_id" {
  type        = string
  default     = "standard-v1"
  description = "cpu id"
}

### instance_name

variable "instance" {
  type        = string
  default     = "netology-develop-platform"
  description = "instance name"
}

variable "web" {
  type        = string
  default     = "web"
  description = "vm name"
}

variable "db" {
  type        = string
  default     = "db"
  description = "vm name"
}

### ssh vars

variable "metadata" {
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 AAAA_______"
 }
}
