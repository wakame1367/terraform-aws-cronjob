data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

# OIDC Providr is unique in ID Provider IAM
# Create once then, remove from terraform state
# terraform state rm module.trust.aws_iam_openid_connect_provider.tfc_provider
# if you create Id Provider using Terraform, apply below code.
/*
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}
*/

data "aws_iam_openid_connect_provider" "tfc_provider_data" {
  arn = "arn:aws:iam::738591566353:oidc-provider/app.terraform.io"
}

resource "aws_iam_role" "tfc_role" {
  name = "${var.project}-tfc-role-${var.env}"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Principal": {
			"Federated": "${data.aws_iam_openid_connect_provider.tfc_provider_data.arn}"
		},
		"Action": "sts:AssumeRoleWithWebIdentity",
		"Condition": {
			"StringEquals": {
				"${var.tfc_hostname}:aud": "${one(data.aws_iam_openid_connect_provider.tfc_provider_data.client_id_list)}"
			},
			"StringLike": {
				"${var.tfc_hostname}:sub": "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
			}
		}
	}]
}
EOF
}

resource "aws_iam_policy" "tfc_policy" {
  name        = "${var.project}-tfc-policy-${var.env}"
  description = "TFC run policy"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": [
			"iam:*",
			"ecr:*",
			"s3:*",
     		 "lambda:*",
		],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}
