resource "aws_cloudtrail" "main" {
  name                          = "${var.project}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.raw_reports.id  # For demo — usually separate bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
