resource "yandex_vpc_network" "vpc_ci-cd" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "subnet_ci-cd" {
  name           = var.subnet_name
  zone           = var.zone_a
  network_id     = yandex_vpc_network.vpc_ci-cd.id
  v4_cidr_blocks = var.cidr_a
}
