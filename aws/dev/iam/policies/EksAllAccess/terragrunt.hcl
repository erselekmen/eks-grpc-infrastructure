include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  name        = "EksAllAccess"
}

terraform {
  source = "../../../../..//modules/terraform-aws-iam/modules/EksAllAccess/"
}

inputs = {
  name        = "${local.name}-${local.common_vars.namespace}-${local.common_vars.environment}"
  path        = "/"
  description = "EKS All Access for GRPC-EKS Project"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        },
        {
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:*:${local.env_vars.account_id}:parameter/aws/*",
                "arn:aws:ssm:*::parameter/aws/*"
            ],
            "Effect": "Allow"
        },
        {
             "Action": [
               "kms:CreateGrant",
               "kms:DescribeKey"
             ],
             "Resource": "*",
             "Effect": "Allow"
        },
        {
             "Action": [
               "logs:PutRetentionPolicy"
             ],
             "Resource": "*",
             "Effect": "Allow"
        }
    ]
}
EOF

  tags = local.common_vars.tags
}
