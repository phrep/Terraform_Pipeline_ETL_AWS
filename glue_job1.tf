resource "aws_glue_job" "xx_terraform_test_job1" {

  name     = "xx_terraform_test_job1"
  role_arn = "arn:aws:iam::xxxxxxxxxx:role/AWS-Role-xxxx"

  glue_version = "5.0"

  worker_type       = "G.1X"
  number_of_workers = 10

  max_retries = 0
  timeout     = 480

  execution_property {
    max_concurrent_runs = 1
  }

  command {
    name            = "glueetl"
    script_location = "s3://xxxx-code-bucket/script.py"
    python_version  = "3"
  }

  default_arguments = {

    "--job-language"                 = "python"
    "--enable-metrics"               = "true"
    "--enable-observability-metrics" = "true"
    "--enable-glue-datacatalog"      = "true"
    "--job-bookmark-option"          = "job-bookmark-disable"

    "--INPUT_PATH"  = "s3://xxxx-source-data-bucket/"
    "--OUTPUT_PATH" = "s3://xxxx-code-bucket/glue_spark_Logs/"

    "--TempDir" = "s3://xxxx-code-bucket/glue_spark_Logs/"

    "--spark-event-logs-path" = "s3://xxxx-code-bucket/glue_spark_Logs/"

    "--conf" = "spark.eventLog.rolling.enabled=true"
  }

  execution_class = "STANDARD"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}