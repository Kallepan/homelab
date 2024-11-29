resource "minio_iam_group" "argo" {
  name = "argo"
}

resource "minio_iam_user" "argo" {
  name = "argo"
}

resource "minio_iam_group_membership" "argo_group_membership" {
  name  = "argo_group_membership"
  users = [minio_iam_user.argo.name]
  group = minio_iam_group.argo.name
}

resource "minio_iam_policy" "argo_policy" {
  name   = "argo_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads"
      ],
      "Resource": [
        "arn:aws:s3:::argo-workflows-artifacts"
    ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": [
        "arn:aws:s3:::argo-workflows-artifacts/*"
     ]
    }
  ]
}
EOF
}

resource "minio_iam_group_policy_attachment" "argo_policy_attachment" {
  policy_name = minio_iam_policy.argo_policy.id
  group_name  = minio_iam_group.argo.name
}

resource "minio_s3_bucket" "argo_workflows_bucket" {
  bucket = "argo-workflows-artifacts"
  acl    = "private"
}
