resource "aws_s3_bucket" "raw_reports" {
  bucket = "saffaran-turbine-raw-${random_id.bucket_id.hex}"      force_destroy = true
  tags = {
    Name = "saffaran-turbine-raw"      }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
