import os
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource("dynamodb")
s3 = boto3.resource("s3")


def lambda_handler(event, context):
    # Get the table and bucket from environment variables
    table_name = os.environ["DYNAMODB_TABLE"]
    bucket_name = os.environ["S3_BUCKET"]

    # Get the id from the event
    id = event["pathParameters"]["id"]

    # Get the table
    table = dynamodb.Table(table_name)

    try:
        # Get the item from DynamoDB
        response = table.get_item(Key={"id": id})

        # Check if item exists
        if "Item" in response:
            item = response["Item"]

            # Get the S3 object key from the item
            s3_object_key = item["url"]

            # Delete the S3 object
            s3.Object(bucket_name, s3_object_key).delete()

            # Delete the item from DynamoDB
            table.delete_item(Key={"id": id})
            
            return {
                "statusCode": 200,
                "body": f"Successfully deleted item {id} and its associated S3 object",
            }
        else:
            return {"statusCode": 404, "body": f"Item {id} not found"}
    except ClientError as e:
        print(e.response["Error"]["Message"])
        return {"statusCode": 500, "body": "An error occurred"}
