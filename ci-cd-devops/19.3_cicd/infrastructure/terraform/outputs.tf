output "VMs_data" {
  value = {
    vm_name1 = yandex_compute_instance.sonarqube.name
    fqdn_name1 = yandex_compute_instance.sonarqube.fqdn
    external_ip1 = yandex_compute_instance.sonarqube.network_interface.0.nat_ip_address
    
    vm_name2 = yandex_compute_instance.nexus.name
    fqdn_name2 = yandex_compute_instance.nexus.fqdn
    external_ip2 = yandex_compute_instance.nexus.network_interface.0.nat_ip_address
 }
}
