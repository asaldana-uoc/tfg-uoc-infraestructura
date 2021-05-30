# Definim una local per definir l'entorn. S'utilitzarà en la resta del codi per facilitar
# la reutilització per la creació de nous entorns
locals {
  environment = "devel"
}

# Es crea un trigger específic en Google Cloud Build per a que
# s'executi cada vegada que es detecti un canvi nou en la branca principal main.
# Només s'aplicarà terraform quan els canvis afectin a l'entorn devel.
resource "google_cloudbuild_trigger" "cd_trigger" {
  name        = "tfg-uoc-cd-${local.environment}-infraestructura"
  description = "Trigger que s'executarà cada nou commit a la branca main quan s'hagin modificat arxius del directori ${local.environment}"
  filename    = "gcp/common/cd/infraestructura/${local.environment}/cloudbuild.yaml"
  included_files = ["gcp/${local.environment}/**"]

  substitutions = {
    _ENVIRONMENT = local.environment
  }

  github {
    owner = "asaldana-uoc"
    name  = "tfg-uoc-infraestructura"
    push {
      branch = "main"
    }
  }
}


# Utilitzem el proveïdor google al haver de crear recursos a GCP
provider "google" {
  project = "tfg-uoc-313418"
}

# Aquesta secció es per definir la ubicació on s'emmagatzemarà l'estat de terraform.
# Utilitzem el bucket tfg-uoc-tfstate-eu i desem la configuració del trigger de Cloud Build en la ruta common/cd/infraestructura/devel
terraform {
  backend "gcs" {
    bucket = "tfg-uoc-tfstate-eu"
    prefix = "common/cd/infraestructura/devel"
  }
}
