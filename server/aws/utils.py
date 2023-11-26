from botocore.exceptions import ClientError, NoCredentialsError

from server.aws.client import Client


def fetch_registry_from_s3(bucket_name, object_name, local_file_path):
    aws_client = Client()
    try:
        aws_client.download_file(bucket_name, object_name, local_file_path)
    except NoCredentialsError:
        print("Credentials not available")
        raise
    except ClientError as e:
        error_message = e.response["Error"]["Message"]
        print(f"An error occurred: {e} - {error_message}")
        raise
