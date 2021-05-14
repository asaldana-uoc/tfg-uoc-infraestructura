module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = local.project_id
  network_name = format("%s-%s", local.prefix_name, "vpc")
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = format("%s-%s", local.prefix_name, "subnet-private")
      subnet_ip             = "172.17.0.0/23"
      subnet_region         = local.region
    },
    {
      subnet_name           = format("%s-%s", local.prefix_name, "subnet-public")
      subnet_ip             = "172.18.0.0/23"
      subnet_region         = local.region
    }
  ]
}
