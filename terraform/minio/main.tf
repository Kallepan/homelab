### Argo Workflows ###
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

import {
  to = minio_s3_bucket.argo_workflows_bucket
  id = "argo-workflows-artifacts"
}

resource "minio_s3_bucket" "argo_workflows_bucket" {
  bucket = "argo-workflows-artifacts"
  acl    = "private"
}

### Backups ###
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

import {
  to = minio_s3_bucket.backups_bucket
  id = "backups"
}

resource "minio_s3_bucket" "backups_bucket" {
  bucket = "backups"
  acl    = "private"
}

### Runner ###
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

import {
  to = minio_s3_bucket.gitlab_runner_bucket
  id = "gitlab-runner"
}
resource "minio_s3_bucket" "gitlab_runner_bucket" {
  bucket = "gitlab-runner"
  acl    = "private"
}

### Gitlab ###

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

import {
  to = minio_s3_bucket.gitlab_artifacts_bucket
  id = "gitlab-artifacts"
}
resource "minio_s3_bucket" "gitlab_artifacts_bucket" {
  bucket = "gitlab-artifacts"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_backups_bucket
  id = "gitlab-backups"
}
resource "minio_s3_bucket" "gitlab_backups_bucket" {
  bucket = "gitlab-backups"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_backups_tmp_bucket
  id = "gitlab-backups-tmp"
}
resource "minio_s3_bucket" "gitlab_backups_tmp_bucket" {
  bucket = "gitlab-backups-tmp"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_mr_diffs_bucket
  id = "gitlab-mr-diffs"
}
resource "minio_s3_bucket" "gitlab_mr_diffs_bucket" {
  bucket = "gitlab-mr-diffs"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_lfs_bucket
  id = "gitlab-lfs"
}
resource "minio_s3_bucket" "gitlab_lfs_bucket" {
  bucket = "gitlab-lfs"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_uploads_bucket
  id = "gitlab-uploads"
}
resource "minio_s3_bucket" "gitlab_uploads_bucket" {
  bucket = "gitlab-uploads"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_packages_bucket
  id = "gitlab-packages"
}
resource "minio_s3_bucket" "gitlab_packages_bucket" {
  bucket = "gitlab-packages"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_dependency_proxy_bucket
  id = "gitlab-dependency-proxy"
}
resource "minio_s3_bucket" "gitlab_dependency_proxy_bucket" {
  bucket = "gitlab-dependency-proxy"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_terraform_state_bucket
  id = "gitlab-terraform-state"
}
resource "minio_s3_bucket" "gitlab_terraform_state_bucket" {
  bucket = "gitlab-terraform-state"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_ci_secure_files_bucket
  id = "gitlab-ci-secure-files"
}
resource "minio_s3_bucket" "gitlab_ci_secure_files_bucket" {
  bucket = "gitlab-ci-secure-files"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_pages_bucket
  id = "gitlab-pages"
}
resource "minio_s3_bucket" "gitlab_pages_bucket" {
  bucket = "gitlab-pages"
  acl    = "private"
}

import {
  to = minio_s3_bucket.gitlab_registry_storage_bucket
  id = "gitlab-registry-storage"
}
resource "minio_s3_bucket" "gitlab_registry_storage_bucket" {
  bucket = "gitlab-registry-storage"
  acl    = "private"
}

### Harbor ###
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

import {
  to = minio_s3_bucket.harbor_bucket
  id = "harbor"
}
resource "minio_s3_bucket" "harbor_bucket" {
  bucket = "harbor"
  acl    = "private"
}

### Longhorn ###
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

import {
  to = minio_s3_bucket.longhorn
  id = "longhorn"
}
resource "minio_s3_bucket" "longhorn" {
  bucket = "longhorn"
}
