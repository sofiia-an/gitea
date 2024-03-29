output "bucket_id" {
    description = "The ID of the created S3 bucket"
    value = aws_s3_bucket.gitea_bucket.id
}

output "bucket_name" {
    description = "The bucket name"
    value = aws_s3_bucket.gitea_bucket.bucket
}

output "object_key" {
    description = "The object key"
    value = aws_s3_object.dockerrun_json.key
}