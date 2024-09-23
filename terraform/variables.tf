variable "config_file" {
  description = "Percorso al file JSON contenente le configurazioni dell'infrastrattura"
  type        = string
  default     = "../configs.json"
}

variable "project_name" {
  description = "Name of the Incus project"
  type = string
  default = "default"
}