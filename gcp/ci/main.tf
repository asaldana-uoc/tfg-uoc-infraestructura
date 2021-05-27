# Es crea un trigger específic en Google Cloud Build per a que
# s'executi en cada Pull Request a la que es detecti un commit nou
resource "google_cloudbuild_trigger" "ci_trigger" {
  name        = "tfg-uoc-infraestructura-ci"
  description = "Trigger que s'executarà en cada Pull Request nova"
  filename    = "gcp/ci/cloudbuild.yaml"

  github {
    owner = "asaldana-uoc"
    name  = "tfg-uoc-infraestructura"
    pull_request {
      branch          = ".*"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }
}


# Utilitzem el proveïdor google al haver de crear recursos a GCP
provider "google" {
  project = "tfg-uoc-313418"
}

# Aquesta secció es per definir la ubicació on s'emmagatzemarà l'estat de terraform.
# Utilitzem el bucket tfg-uoc-tfstate-eu i desem la configuració del VPC en la ruta development/europe-west1/vpc
terraform {
  backend "gcs" {
    bucket = "tfg-uoc-tfstate-eu"
    prefix = "ci"
  }
}
