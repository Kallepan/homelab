resource "minio_iam_group" "gitlab_runner" {
  name = "gitlab_runner"
}

resource "minio_iam_user" "gitlab_runner" {
  name = "gitlab_runner"
}

resource "minio_iam_group_membership" "gitlab_runner" {
  name  = "gitlab_runner_group_membership"
  users = [minio_iam_user.gitlab_runner.name]
  group = minio_iam_group.gitlab_runner.name
}

resource "minio_iam_policy" "gitlab_runner_policy" {
  name   = "gitlab_runner_policy"
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
        "arn:aws:s3:::gitlab-runner"
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
        "arn:aws:s3:::gitlab-runner/*"
      ]
    }
  ]
}
EOF
}

resource "minio_s3_bucket" "gitlab_runner_bucket" {
  bucket = "gitlab-runner"
  acl    = "private"
}
