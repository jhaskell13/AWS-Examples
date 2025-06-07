## Create a bucket or use existing one

## Create a file and upload with SSE-S3 (default encryption)

```
echo "Hello World" > hello.txt
aws s3 cp hello.txt s3://your-bucket
```

## Reupload object with SSE-KMS encryption
### Create KMS Key

```
aws kms create-key
```

### Put Object with encryption of KMS

```
aws s3api put-object \
    --bucket your-bucket \
    --key hello.txt \
    --body hello.txt \
    --server-side-encryption "aws:kms" \
    --ssekms-key-id kms-key-id
```

## Reupload object with SSE-C encryption

```
openssl rand -out ssec.key 32

aws s3 cp hello.txt s3://your-buckey/hello.txt \
    --sse-c AES256 \
    --sse-c-key fileb://ssec.key
```
