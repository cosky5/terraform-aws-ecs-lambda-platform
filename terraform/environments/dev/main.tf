terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source              = "../../modules/vpc"
  project_name        = "aws-platform"
  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["eu-north-1a", "eu-north-1b"]
}

module "sqs" {
  source       = "../../modules/sqs"
  project_name = "aws-platform"
  environment  = "dev"
}

module "lambda" {
  source            = "../../modules/lambda"
  project_name      = "aws-platform"
  environment       = "dev"
  function_name     = "event-processor"
  lambda_source_dir = "${path.module}/../../../lambda"
  queue_arn         = module.sqs.queue_arn
  queue_name        = module.sqs.queue_name
}