terraform {
  backend "remote" {
    organization = "bola-rotimi"

    workspaces {
      name = "rotimi-dev"
    }
  }
}