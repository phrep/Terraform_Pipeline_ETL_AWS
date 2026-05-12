# S3 Bucket for Source Data
resource "aws_s3_bucket" "xxx-source-data-bucket" {
  bucket        = "xxx-source-data-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_object" "data-object" {
  bucket = aws_s3_bucket.xxx-source-data-bucket.bucket
  key    = "organizations.csv"
  source = "xxxxxx/s3_read_write_etl_glue_pipeline/data_file/organizations.csv"
}

# S3 Bucket for Traget 
resource "aws_s3_bucket" "xxx-target-data-bucket" {
  bucket        = "xxxx-target-data-bucket"
  force_destroy = true
}


# S3 Bucket for saving code
resource "aws_s3_bucket" "xxx-code-bucket" {
  bucket        = "xxx-code-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_object" "code-data-object" {
  bucket = aws_s3_bucket.xxx-code-bucket.bucket
  key    = "script.py"
  source = "xxxxxx/s3_read_write_etl_glue_pipeline/data_file/script.py"
  etag   = filemd5("${path.module}/data_file/script.py")
}
