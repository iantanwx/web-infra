variable "project" {
  type        = "string"
  description = "The project ID to add the bindings too."
}

variable "members" {
  type        = list(string)
  description = "A list of members to add the specified roles to."
}

variable "roles" {
  type        = list(string)
  description = "A list of roles to add to the specified members."
}

