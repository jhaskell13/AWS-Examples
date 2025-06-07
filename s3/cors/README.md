## Create a bucket

```
aws s3 mb s3://aws-examples-1234
```

## Change Block Public Access

```
aws s3api put-public-block-access \
    --bucket aws-examples-1234 \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

## Create bucket policy

```
aws s3api put-bucket-policy \
    --bucket aws-examples-1234 \
    --policy file://../bucket-policies/static-website-hosting.json
```

## Turn on static website hosting

```
aws s3api put-bucket-website \
    --bucket aws-examples-1234 \
    --website-configuration file://website.json
```

## Upload index.html file, include resource that would be cross-origin

```
aws s3 cp index.html s3://aws-examples-1234
```

## View website to see if index.html is there

```
http://aws-examples-1234.s3-website.us-east-2.amazonaws.com
```

## Create API Gateway in the Console with basic mock /hello POST method.
### Apply simple JSON in Integration Response config: { "message": "Hello API World" }

## Use basic JS fetch to invoke this API from index.html and reupload file to Bucket

```js
<script type="text/javascript">
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'https://t16op26co5.execute-api.us-east-2.amazonaws.com/prod/hello', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onreadystatechange = () => {
        if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            const res = JSON.parse(this.responseText);
            console.log('results', res);
        }
    };
    xhr.send();
</script>
```

## Check website to get an expected CORS error

```
http://aws-examples-1234.s3-website.us-east-2.amazonaws.com
```

## Apply a CORS policy to the bucket

```
aws s3api put-bucket-cors \
    --bucket aws-examples-1234 \
    --cors-configuration file://cors.json

cors.json:
{
  "CORSRules": [
    {
      "AllowedOrigins": ["https://t16op26co5.execute-api.us-east-2.amazonaws.com"],
      "AllowedHeaders": ["*"],
      "AllowedMethods": ["PUT", "POST", "DELETE"],
      "MaxAgeSeconds": 3000,
      "ExposeHeaders": ["x-amz-server-side-encryption"]
    }
  ]
}
```

## Enable CORS on API Gateway
### Resource (/hello) -> Enable Cors -> Check POST -> Save -> Redeploy API
