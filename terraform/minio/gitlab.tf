resource "minio_iam_group" "gitlab" {
  name = "gitlab"
}

resource "minio_iam_user" "gitlab" {
  name = "gitlab"
}

resource "minio_iam_group_membership" "gitlab_group_membership" {
  name  = "gitlab_group_membership"
  users = [minio_iam_user.gitlab.name]
  group = minio_iam_group.gitlab.name

}

resource "minio_iam_policy" "gitlab_policy" {
  name   = "gitlab_policy"
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
        "arn:aws:s3:::gitlab-artifacts",
        "arn:aws:s3:::gitlab-backups",
        "arn:aws:s3:::gitlab-backups-tmp",
        "arn:aws:s3:::gitlab-mr-diffs",
        "arn:aws:s3:::gitlab-lfs",
        "arn:aws:s3:::gitlab-uploads",
        "arn:aws:s3:::gitlab-packages",
        "arn:aws:s3:::gitlab-dependency-proxy",
        "arn:aws:s3:::gitlab-terraform-state",
        "arn:aws:s3:::gitlab-ci-secure-files",
        "arn:aws:s3:::gitlab-pages",
        "arn:aws:s3:::gitlab-registry-storage"
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
        "arn:aws:s3:::gitlab-artifacts/*",
        "arn:aws:s3:::gitlab-backups/*",
        "arn:aws:s3:::gitlab-backups-tmp/*",
        "arn:aws:s3:::gitlab-mr-diffs/*",
        "arn:aws:s3:::gitlab-lfs/*",
        "arn:aws:s3:::gitlab-uploads/*",
        "arn:aws:s3:::gitlab-packages/*",
        "arn:aws:s3:::gitlab-dependency-proxy/*",
        "arn:aws:s3:::gitlab-terraform-state/*",
        "arn:aws:s3:::gitlab-ci-secure-files/*",
        "arn:aws:s3:::gitlab-pages/*",
        "arn:aws:s3:::gitlab-registry-storage/*"
      ]
    }
  ]
}
EOF
}

resource "minio_iam_group_policy_attachment" "gitlab_policy_attachment" {
  policy_name = minio_iam_policy.gitlab_policy.id
  group_name  = minio_iam_group.gitlab.name
}

resource "minio_s3_bucket" "gitlab_artifacts_bucket" {
  bucket = "gitlab-artifacts"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_backups_bucket" {
  bucket = "gitlab-backups"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_backups_tmp_bucket" {
  bucket = "gitlab-backups-tmp"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_mr_diffs_bucket" {
  bucket = "gitlab-mr-diffs"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_lfs_bucket" {
  bucket = "gitlab-lfs"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_uploads_bucket" {
  bucket = "gitlab-uploads"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_packages_bucket" {
  bucket = "gitlab-packages"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_dependency_proxy_bucket" {
  bucket = "gitlab-dependency-proxy"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_terraform_state_bucket" {
  bucket = "gitlab-terraform-state"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_ci_secure_files_bucket" {
  bucket = "gitlab-ci-secure-files"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_pages_bucket" {
  bucket = "gitlab-pages"
  acl    = "private"
}

resource "minio_s3_bucket" "gitlab_registry_storage_bucket" {
  bucket = "gitlab-registry-storage"
  acl    = "private"
}
