output "VMs_data" {
  value = {
    vm_name1 = yandex_compute_instance.web.name
    fqdn_name1 = yandex_compute_instance.web.fqdn
    external_ip1 = yandex_compute_instance.web.network_interface.0.nat_ip_address
    vm_name2 = yandex_compute_instance.db.name
    fqdn_name2 = yandex_compute_instance.db.fqdn
    external_ip2 = yandex_compute_instance.db.network_interface.0.nat_ip_address
 }
}
