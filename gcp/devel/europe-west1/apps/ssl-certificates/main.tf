# Creem una certificat SSL autogestionat per Google per la URL de l'aplicació de devel
resource "google_compute_managed_ssl_certificate" "tfg_uoc_app_devel_cert" {
  name = "tfg-uoc-app-devel-cert"

  managed {
    domains = ["app-devel.asaldana.tech"]
  }
}

# Creem una certificat SSL autogestionat per Google per la URL de l'aplicació de prod
resource "google_compute_managed_ssl_certificate" "tfg_uoc_app_prod_cert" {
  name = "tfg-uoc-app-prod-cert"

  managed {
    domains = ["app-prod.asaldana.tech"]
  }
}

# Utilitzem el proveïdor google al haver de crear recursos a GCP
provider "google" {
  project = "tfg-uoc-313418"
}

# Aquesta secció es per definir la ubicació on s'emmagatzemarà l'estat de terraform.
# Utilitzem el bucket tfg-uoc-tfstate-eu i desem la configuració dels certifats SSL autogestionats
# en la ruta devel/europe-west1/apps/static-ips
terraform {
  backend "gcs" {
    bucket = "tfg-uoc-tfstate-eu"
    prefix = "devel/europe-west1/apps/ssl-certificates"
  }
}
