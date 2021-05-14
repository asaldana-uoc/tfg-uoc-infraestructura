# Mòdul del registry per a crear un VPC, una network i dues subnetworks amb
# l'adreçament IP especificat en el disseny de la topologia de xarxa
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.2.2"

  project_id   = local.project_id
  network_name = format("%s-%s", local.prefix_name, "vpc")
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = format("%s-%s", local.prefix_name, "subnet-private")
      subnet_ip     = "172.17.0.0/23"
      subnet_region = local.region
    },
    {
      subnet_name   = format("%s-%s", local.prefix_name, "subnet-public")
      subnet_ip     = "172.18.0.0/23"
      subnet_region = local.region
    }
  ]
}

# Mòdul del registry per a crear un Cloud NAT per donar sortida a Internet
# a les instàncies que no tinguin adreçament IP públic
module "cloud-router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "1.0.0"

  name    = format("%s-%s", local.prefix_name, "router")
  project = local.project_id
  region  = local.region
  network = module.vpc.network_name

  nats = [{
    name                               = format("%s-%s", local.prefix_name, "nat-gw")
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [{
      name                    = format("%s-%s", local.prefix_name, "subnet-private")
      source_ip_ranges_to_nat = ["172.17.0.0/23"]
    }]
  }]
}
