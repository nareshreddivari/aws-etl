import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    for record in event['Records']:
        src_bucket = record['s3']['bucket']['name']
        src_key = record['s3']['object']['key']

        # Destination
        dst_bucket = src_bucket
        dst_key = src_key.replace("extract/", "load/")

        # Copy file from extract → load
        s3.copy_object(
            Bucket=dst_bucket,
            CopySource={'Bucket': src_bucket, 'Key': src_key},
            Key=dst_key
        )

        print(f"Moved {src_key} → {dst_key}")
