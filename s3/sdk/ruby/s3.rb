require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

bucket_name = ENV['BUCKET_NAME']
region = 'us-east-2'

# S3 Client
client = Aws::S3::Client.new

# Create S3 Bucket based on specified ENV var
resp = client.create_bucket({
  bucket: bucket_name,
  create_bucket_configuration: {
      location_constraint: region
  }
})

# Generate random number of files to uplaod
num_files = 1 + rand(6)
puts "num_files: #{num_files}"

num_files.times.each do |i|
    puts "i: #{i}"
    filename = "file_#{i}.txt"
    output_path = "/tmp/#{filename}"

    # Write random data
    File.open(output_path, "w") do |f|
        f.write(SecureRandom.uuid)
    end
    
    # Upload file to bucket
    File.open(output_path, "rb") do |f|
        client.put_object(
            bucket: bucket_name,
            key: filename,
            body: f
        )
    end
end
