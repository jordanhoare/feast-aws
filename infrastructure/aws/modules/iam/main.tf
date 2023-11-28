# infrastructure/aws/modules/iam/main.tf
resource "aws_iam_role_policy" "github_actions_role" {
  name   = "github_actions_role"
  role   = aws_iam_role.github_actions_role.id
  policy = data.aws_iam_policy_document.github_actions_role.json
}


resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.thumbprint_list
}

resource "aws_iam_policy" "pass_role_policy" {
  name        = "PassRolePolicy"
  description = "Allows passing of ECS task role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "iam:PassRole",
        Effect = "Allow",
        Resource = "arn:aws:iam::432702836969:role/ecs_task_role"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "pass_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}

resource "aws_iam_role" "github_actions_role" {
  name = "github_actions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc.arn
        },
        Condition = {
          StringLike = {
            "${aws_iam_openid_connect_provider.github_oidc.url}:sub": "repo:${var.repository_name}:*",
            "${aws_iam_openid_connect_provider.github_oidc.url}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "github_actions_role" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
    ]
    resources = ["*"] # This gives permissions on all ECR resources; consider scoping to specific resources.
  }
}


resource "aws_iam_role_policy" "ecs_task_policy" {
  name   = "ecs_task_policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_policy.json
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc.arn
        },
        Condition = {
          StringLike = {
            "${aws_iam_openid_connect_provider.github_oidc.url}:sub": "repo:${var.repository_name}:*",
            "${aws_iam_openid_connect_provider.github_oidc.url}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecs:CreateService",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:DescribeServices",
      "ecs:ListServices",
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:ListClusters",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
    ]
    resources = ["*"] # You might want to restrict this to specific resources.
  }
}
