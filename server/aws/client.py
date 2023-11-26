import boto3

from server.config import settings


class Client:
    def __init__(self):
        self.client = boto3.client(
            "s3",
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            region_name=settings.AWS_REGION,
        )

    def download_file(self, bucket_name, object_name, local_file_path):
        self.client.download_file(bucket_name, object_name, local_file_path)
