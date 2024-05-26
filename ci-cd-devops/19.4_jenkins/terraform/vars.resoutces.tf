### vms_resources
variable "vms_resources" {
  type            = map(map(number))
  default         = {
    jenkins-master = {
      cores       = 2
      memory      = 4
      fraction    = 5
    }
    jenkins-agent     = {
      cores       = 2
      memory      = 4
      fraction    = 5
    }
  }
}

variable "vm_os_centos" {
  type        = string
  default     = "centos-7"
  description = "os version"
}

variable "vm_cpu_id_v1" {
  type        = string
  default     = "standard-v1"
  description = "cpu id v1"
}

### vm_name
variable "vm_01" {
  type        = string
  default     = "jenkins-master"
  description = "vm name"
}

variable "vm_02" {
  type        = string
  default     = "jenkins-agent"
  description = "vm name"
}
