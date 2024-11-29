resource "minio_iam_group" "harbor" {
  name = "harbor"
}

resource "minio_iam_user" "harbor" {
  name = "harbor"
}

resource "minio_iam_group_membership" "harbor_group_membership" {
  name  = "harbor_group_membership"
  users = [minio_iam_user.harbor.name]
  group = minio_iam_group.harbor.name

}

resource "minio_iam_policy" "harbor_policy" {
  name   = "harbor_policy"
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
      "Resource": ["arn:aws:s3:::harbor"]
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
      "Resource": ["arn:aws:s3:::harbor/*"]
    }
  ]
}
EOF
}

resource "minio_iam_group_policy_attachment" "harbor_policy_attachment" {
  policy_name = minio_iam_policy.harbor_policy.id
  group_name  = minio_iam_group.harbor.name
}

resource "minio_s3_bucket" "harbor_bucket" {
  bucket = "harbor"
  acl    = "private"
}
