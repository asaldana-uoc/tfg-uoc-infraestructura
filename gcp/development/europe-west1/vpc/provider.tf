# Utilitzem el proveïdor google al haver de crear recursos a GCP
provider "google" {
  project = local.project_id
  region  = local.region
}

# Aquesta secció es per definir la ubicació on s'emmagatzemarà l'estat de terraform.
# Utilitzem el bucket tfg-uoc-tfstate-eu i desem la configuració del VPC en la ruta development/europe-west1/vpc
terraform {
  backend "gcs" {
    bucket = "tfg-uoc-tfstate-eu"
    prefix = "development/europe-west1/vpc"
  }
}
