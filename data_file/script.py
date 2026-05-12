import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(
    sys.argv,
    ['JOB_NAME', 'INPUT_PATH', 'OUTPUT_PATH']
)

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

job = Job(glueContext)
job.init(args['JOB_NAME'], args)

input_path = args['INPUT_PATH']
output_path = args['OUTPUT_PATH']

AWSGlueDataCatalog_node = glueContext.create_dynamic_frame.from_catalog(
    database="org-report",
    table_name="ph_source_data_bucket",
    transformation_ctx="AWSGlueDataCatalog_node"
)

ChangeSchema_node = ApplyMapping.apply(
    frame=AWSGlueDataCatalog_node,
    mappings=[
        ("index", "long", "index", "long"),
        ("organization id", "string", "organization id", "string"),
        ("name", "string", "name", "string"),
        ("website", "string", "website", "string"),
        ("country", "string", "country", "string"),
        ("description", "string", "description", "string"),
        ("founded", "long", "founded", "long"),
        ("industry", "string", "industry", "string"),
        ("number of employees", "long", "number of employees", "long")
    ],
    transformation_ctx="ChangeSchema_node"
)

AmazonS3_node = glueContext.write_dynamic_frame.from_options(
    frame=ChangeSchema_node,
    connection_type="s3",
    format="csv",
    connection_options={
        "path": output_path,
        "partitionKeys": []
    },
    transformation_ctx="AmazonS3_node"
)

job.commit()