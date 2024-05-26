output "VMs_data" {
  value = {
    vm_name1 = yandex_compute_instance.jenkins-master.name
    fqdn_name1 = yandex_compute_instance.jenkins-master.fqdn
    external_ip1 = yandex_compute_instance.jenkins-master.network_interface.0.nat_ip_address
    
    vm_name2 = yandex_compute_instance.jenkins-agent.name
    fqdn_name2 = yandex_compute_instance.jenkins-agent.fqdn
    external_ip2 = yandex_compute_instance.jenkins-agent.network_interface.0.nat_ip_address
 }
}
