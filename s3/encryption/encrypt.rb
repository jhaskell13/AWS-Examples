require 'openssl'
require 'aws-sdk-s3'

key = OpenSSL::PKey::RSA.new(1024)

bucket = 'aws-examples-jh'
fileKey = 'handshake.txt'

client = Aws::S3::EncryptionV2::Client.new(
  encryption_key: key,
  key_wrap_schema: :rsa_oaep_sha1,
  content_encryption_schema: :aes_gcm_no_padding,
  security_profile: :v2
)

res = client.put_object(bucket: bucket, key: fileKey, body: 'handshake')
puts "PUT"
puts res

res = client.get_object(bucket: bucket, key: fileKey).body.read
puts "GET WITH KEY"
puts res

res = Aws::S3::Client.new.get_object(bucket: bucket, key: fileKey).body.read
puts "GET WITHOUT KEY"
puts res
