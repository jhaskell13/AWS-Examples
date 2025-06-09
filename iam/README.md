## Create IAM Policy

```sh
aws iam create-policy \
    --policy-name policy-playground \
    --policy-document file://policy-playground.json
```

## Attach Policy to User

```sh
aws iam attach-user-policy \
    --policy-arn arn:aws:iam::553660602111:policy/policy-playground \
    --user-name test-user
```
