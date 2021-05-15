# S'utilitzen constants tipus locals per utilitzar-les en la creació dels recursos
# per seguir un patró en els noms dels recursos
locals {
  region      = "europe-west1"
  zones       = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  project_id  = "tfg-uoc-313418"
  prefix_name = "tfg-uoc"
}
