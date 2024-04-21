output "VMs_data" {
  value = {
    vm_name1     = yandex_compute_instance.clickhouse.name
    fqdn_name1   = yandex_compute_instance.clickhouse.fqdn
    external_ip1 = yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address

    vm_name2     = yandex_compute_instance.vector.name
    fqdn_name2   = yandex_compute_instance.vector.fqdn
    external_ip2 = yandex_compute_instance.vector.network_interface.0.nat_ip_address

    vm_name3     = yandex_compute_instance.lighthouse.name
    fqdn_name3   = yandex_compute_instance.lighthouse.fqdn
    external_ip3 = yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address
  }
}
