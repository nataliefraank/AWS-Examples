#Required libraries
require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

#S3 bucket configuration
bucket_name = ENV['BUCKET_NAME']
region = 'us-east-2'

#Intialize AWS S3 client
client = Aws::S3::Client.new

#Create S3 bucket
resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
        location_constraint: region
    }
})
# binding.pry

#Determine number of files to create
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

#Loop to create and upload each file
number_of_files.times.each do |i|
    puts "i: #{i}"
    filename = "file_#{i}.txt"
    output_path="/tmp/#{filename}"

    File.open(output_path, "w") do |f|
        f.write SecureRandom.uuid
    end

    File.open(output_path, 'rb') do |file|
        client.put_object(
            bucket: bucket_name,
            key: filename,
            body:file
        )
    end
end