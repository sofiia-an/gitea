resource "aws_s3_bucket" "gitea_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_access" {
  bucket = aws_s3_bucket.gitea_bucket.id
  block_public_acls = false

}

resource "aws_s3_object" "dockerrun_json" {
  bucket = aws_s3_bucket.gitea_bucket.id
  key = "Dockerrun.aws.json"
  source = "./Dockerrun.aws.json"
}
