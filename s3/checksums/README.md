## Create a new S3 Bucket

```
aws s3 mb s3://checksums-examples-jh
```

## Create a file that we will do a checksum on

```
echo "Hello Mars" > myfile.txt
```

## Get a checksum of a file

```
md5sum myfile.txt
```

md5sum myfile.txt
# 8ed2d86f12620cdba4c976ff6651637f  myfile.txt

## Upload our file to S3 and look at its Etag

```
aws s3 cp myfile.txt s3://checksums-examples-jh
aws s3api head-object --bucket checksums-examples-jh --key myfile.txt
```

## Upload file with different kind of checksum

### Get CRC32 checksum for myfile.txt
```sh
CRC_HEX=$(crc32 myfile.txt) # Requires libarchive-zip-perl installed

# AWS expects a Base64 encoded binary value of the CRC32 checksum... Why? Who the hell knows...
CRC_B64=$(echo "$CRC_HEX" | xxd -r -p | base64)
echo $CRC_B64
```

### Upload to S3 with CRC32 checksum
```
aws s3api put-object \
    --bucket checksums-examples-jh \
    --key myfile-crc32.txt \
    --body myfile.txt \
    --checksum-algorithm CRC32 
```
