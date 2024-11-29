resource "minio_iam_group" "backups" {
  name = "backups"
}

resource "minio_iam_user" "backups" {
  name = "backups"
}

resource "minio_iam_group_membership" "backups_group_membership" {
  name  = "backups_group_membership"
  users = [minio_iam_user.backups.name]
  group = minio_iam_group.backups.name

}

resource "minio_iam_policy" "backups_policy" {
  name   = "backups_policy"
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
      "Resource": ["arn:aws:s3:::backups"]
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
      "Resource": ["arn:aws:s3:::backups/*"]
    }
  ]
}
EOF
}

resource "minio_iam_group_policy_attachment" "backups_policy_attachment" {
  policy_name = minio_iam_policy.backups_policy.id
  group_name  = minio_iam_group.backups.name
}

resource "minio_s3_bucket" "backups_bucket" {
  bucket = "backups"
  acl    = "private"
}
