# Recurs obligatori pel funcionament del mòdul gke-private-cluster
data "google_client_config" "default" {}

# Recurs obligatori pel funcionament del mòdul gke-private-cluster
provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke-private-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-private-cluster.ca_certificate)
}

# Submòdul del registry per a crear un clúster de Kubernetes amb adreçament IP privat.
# A banda del control plane, també es defineix un grup de nodes que serà on s'executin els pods.
module "gke-private-cluster" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                    = "14.3.0"
  project_id                 = local.project_id
  name                       = format("%s-%s", local.prefix_name, "k8s-cp")
  description                = "Clúster de Kubernetes per a la realització del TFG"
  region                     = local.region
  regional                   = true
  zones                      = local.zones
  network                    = "tfg-uoc-vpc"
  subnetwork                 = "tfg-uoc-subnet-private"
  ip_range_pods              = "tfg-uoc-subnet-private-k8s-pods"
  ip_range_services          = "tfg-uoc-subnet-private-k8s-services"
  create_service_account     = true
  remove_default_node_pool   = true
  http_load_balancing        = true
  default_max_pods_per_node  = 100
  horizontal_pod_autoscaling = true
  network_policy             = true
  network_policy_provider    = "CALICO"
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_authorized_networks = [
    {
      cidr_block   = var.allowed_ip_access_control_plane
      display_name = "Rang d'IPs autoritzades"
    },
  ]

  node_pools = [
    {
      name           = format("%s-%s", local.prefix_name, "k8s-nodes")
      machine_type   = "e2-small"
      node_locations = join(",", local.zones)
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 80
      disk_type      = "pd-standard"
      image_type     = "cos_containerd"
      auto_repair    = true
      auto_upgrade   = true
    },
  ]
}
