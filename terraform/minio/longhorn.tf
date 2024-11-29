resource "minio_iam_group" "longhorn" {
  name = "longhorn"
}

resource "minio_iam_user" "longhorn" {
  name = "longhorn"
}

resource "minio_iam_group_membership" "longhorn" {
  name  = "longhorn_group_membership"
  users = [minio_iam_user.longhorn.name]
  group = minio_iam_group.longhorn.name
}

resource "minio_iam_policy" "longhorn_policy" {
  name   = "longhorn_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantLonghornBackupstoreAccess0",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::longhorn",
        "arn:aws:s3:::longhorn/*"
      ]
    }
  ]
}
EOF
}

resource "minio_iam_group_policy_attachment" "longhorn" {
  group_name  = minio_iam_user.longhorn.name
  policy_name = minio_iam_policy.longhorn_policy.name
}

resource "minio_s3_bucket" "longhorn" {
  bucket = "longhorn"
}
