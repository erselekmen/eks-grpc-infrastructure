include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  name        = "CloudFormationFullAccess"
}

terraform {
  source = "../../../../..//modules/terraform-aws-iam/modules/iam-policy/"
}

inputs = {
  name        = "${local.name}-${local.common_vars.namespace}-${local.common_vars.environment}"
  path        = "/"
  description = "CloudFormation Full Access for GRPC-EKS Project"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = local.common_vars.tags
}
