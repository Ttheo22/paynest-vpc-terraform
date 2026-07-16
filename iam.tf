resource "aws_iam_role" "aws_ssm_role" {
  name = "${var.project}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, { Name = "${var.project}-ssm-role" })

}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.aws_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project}-ssm-instance-profile"
  role = aws_iam_role.aws_ssm_role.name
}

data "aws_iam_policy_document" "ssm_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
    resources = [aws_s3_bucket.paynest_bucket.arn, "${aws_s3_bucket.paynest_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.project}-ssm-policy"
  description = "Policy for SSM to access S3 bucket"
  policy      = data.aws_iam_policy_document.ssm_policy_document.json
}