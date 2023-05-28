locals {
  env     = "production"
  project = "cronjob"
}

module "eventbridge" {
  source = "../../modules/eventbridge"

  project = local.project
  env     = local.env

  lambda_arn = module.lambda.main.arn
}

module "s3_bucket" {
  source = "../../modules/s3"

  bucket = "${local.project}-${local.env}"
  acl    = "private"
}

module "ecr" {
  source = "../../modules/ecr"

  repo_name = "${local.project}-ecr-${local.env}"
}

module "iam" {
  source = "../../modules/iam"

  ecr_arn = module.ecr.ecr_arn
}

module "trust" {
  source  = "../../modules/trust"
  project = local.project
  env     = local.env

  tfc_organization_name = "wakame"
  tfc_workspace_name    = "aws-cronjob"
}

module "lambda" {
  source               = "../../modules/lambda"
  lambda_function_name = "${local.project}-lambda-${local.env}"

  bucket_name        = module.s3.bucket_name
  repository_url     = module.ecr.repository_url
  iam_for_lambda_arn = module.iam.iam_for_lambda.arn
}


