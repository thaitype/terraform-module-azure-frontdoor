variable "attributes" {
  type = object({
    allow_hostname = list(string)
  })
}