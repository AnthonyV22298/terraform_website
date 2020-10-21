terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "VargasNetwork"
        workspaces {
            prefix = "terraform_website"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

module "aws_static_site" {
    source  = "AnthonyV22298/terraform_website/aws"
    version = "1.2.0"

    domain = "duckfarts.net"
    secret = "secret-key"
    tags = {
        Application = "terraform_website"
    }
}

provider "github" {
    owner = "AnthonyV22298"
}

resource "github_actions_secret" "deploy_aws_access_key" {
  repository       = "terraform_website"
  secret_name      = "DEPLOY_AWS_ACCESS_KEY_ID"
  plaintext_value  = module.aws_static_site.deploy-id     
}

resource "github_actions_secret" "deploy_aws_access_secret" {
  repository       = "terraform_website"
  secret_name      = "DEPLOY_AWS_SECRET_ACCESS_KEY"       
  plaintext_value  = module.aws_static_site.deploy-secret 
}
