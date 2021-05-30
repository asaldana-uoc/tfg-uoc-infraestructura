# Variable d'entrada per introduïr l'adreça IP des de la qual es
# podrà accedir al endpoint del control plane de GKE
variable "allowed_ip_access_control_plane" {
  type    = string
  default = "83.32.0.0/12"
}
