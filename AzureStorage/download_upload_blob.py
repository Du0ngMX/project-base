import time
import yaml
import argparse
from azure.storage.blob import BlobServiceClient, BlobClient

def load_config(path='config.yaml'):
    with open(path, 'r') as f:
        return yaml.safe_load(f)

def get_blob_client(config, container_key, blob_path):
    storage_config = config['storage'][container_key]
    connection_string = storage_config['connectionString']
    container_name = storage_config['containerId']
    blob_service = BlobServiceClient.from_connection_string(connection_string)
    return blob_service.get_blob_client(container=container_name, blob=blob_path)

def download_blob(config, container_key, blob_path, output_file):
    retry_count = config['storage']['storageRetryCount']
    retry_interval = config['storage']['storageRetryInterval'] / 1000  # ms → s

    for attempt in range(1, retry_count + 1):
        try:
            print(f"⏳ Attempt {attempt}: Downloading {blob_path}...")
            blob_client = get_blob_client(config, container_key, blob_path)
            with open(output_file, 'wb') as f:
                download_stream = blob_client.download_blob()
                f.write(download_stream.readall())
            print(f"✅ Downloaded to {output_file}")
            return
        except Exception as e:
            print(f"⚠️  Error: {e}")
            if attempt < retry_count:
                time.sleep(retry_interval)
            else:
                print("❌ Download failed after all retries.")

def upload_blob(config, container_key, local_file, blob_path):
    retry_count = config['storage']['storageRetryCount']
    retry_interval = config['storage']['storageRetryInterval'] / 1000  # ms → s

    for attempt in range(1, retry_count + 1):
        try:
            print(f"⏫ Attempt {attempt}: Uploading {local_file} to {blob_path}...")
            blob_client = get_blob_client(config, container_key, blob_path)
            with open(local_file, 'rb') as data:
                blob_client.upload_blob(data, overwrite=True)
            print(f"✅ Uploaded {local_file} to blob {blob_path}")
            return
        except Exception as e:
            print(f"⚠️  Error: {e}")
            if attempt < retry_count:
                time.sleep(retry_interval)
            else:
                print("❌ Upload failed after all retries.")

def main():
    parser = argparse.ArgumentParser(description="Blob Storage Tool")
    parser.add_argument('--mode', choices=['download', 'upload'], required=True, help="Operation mode")
    parser.add_argument('--file', required=True, help="Local file path for upload/download")
    parser.add_argument('--blob', required=True, help="Blob path in storage")
    parser.add_argument('--storage', choices=['current', 'new'], default='current', help="Choose storage config")
    args = parser.parse_args()

    config = load_config()
    container_key = 'currentSysBlobStorage' if args.storage == 'current' else 'newSysBlobStorage'

    if args.mode == 'download':
        download_blob(config, container_key, args.blob, args.file)
    elif args.mode == 'upload':
        upload_blob(config, container_key, args.file, args.blob)

if __name__ == '__main__':
    main()
