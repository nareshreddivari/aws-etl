import boto3
import os

s3 = boto3.client("s3")

def lambda_handler(event, context):
    print("Event received:", event)

    for record in event["Records"]:
        source_bucket = record["s3"]["bucket"]["name"]
        source_key = record["s3"]["object"]["key"]

        print(f"Source: {source_bucket}/{source_key}")

        # Copy only files from extract/ to load/
        if source_key.startswith("extract/"):
            target_key = source_key.replace("extract/", "load/", 1)

            try:
                s3.copy_object(
                    Bucket=source_bucket,
                    CopySource={"Bucket": source_bucket, "Key": source_key},
                    Key=target_key
                )
                print(f"✅ File copied to {target_key}")

            except Exception as e:
                print(f"❌ Error copying file: {e}")
        else:
            print("Skipping file not in extract/ folder")

    return {"status": "done"}
