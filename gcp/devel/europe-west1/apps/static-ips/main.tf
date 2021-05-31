# Creem una reserva d'IP estàtica per l'entorn de desenvolupament
resource "google_compute_address" "tfg_uoc_app_devel_ip_address" {
  name        = "tfg-uoc-app-ip-devel"
  description = "Adreça IP reservada pel balancejador de l'entorn devel"
}

# Creem una reserva d'IP estàtica per l'entorn de producció
resource "google_compute_address" "tfg_uoc_app_prod_ip_address" {
  name        = "tfg-uoc-app-ip-prod"
  description = "Adreça IP reservada pel balancejador de l'entorn prod"
}

# Mostrem quin adreça IP ens han assignat per l'entorn de desenvolupament
output "tfg_uoc_app_devel_ip_address" {
  value = google_compute_address.tfg_uoc_app_devel_ip_address.address
}

# Mostrem quin adreça IP ens han assignat per l'entorn de producció
output "tfg_uoc_app_prod_ip_address" {
  value = google_compute_address.tfg_uoc_app_prod_ip_address.address
}

# Utilitzem el proveïdor google al haver de crear recursos a GCP
provider "google" {
  project = "tfg-uoc-313418"
  region  = "europe-west1"
}

# Aquesta secció es per definir la ubicació on s'emmagatzemarà l'estat de terraform.
# Utilitzem el bucket tfg-uoc-tfstate-eu i desem la configuració de la reserva d'IPs estàtiques
# en la ruta devel/europe-west1/apps-/static-ips
terraform {
  backend "gcs" {
    bucket = "tfg-uoc-tfstate-eu"
    prefix = "devel/europe-west1/apps-/static-ips"
  }
}
