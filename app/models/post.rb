class Post < ActiveRecord::Base

  has_attached_file :local_photo, {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    :s3_host_name => 's3-us-west-2.amazonaws.com',
    :url => "/system/:hash.:extension",
    :hash_secret => ENV['IMG_HASH_KEY']
  }

  validates_attachment_size :local_photo, :less_than => 5.megabytes

  validates_attachment_content_type :local_photo,
      :content_type => [
        'image/gif',
        'image/jpeg',
        'image/pjpeg',
        'image/png',
        'image/svg+xml',
        'image/example'
      ],
      :message => 'Please select a valid image file'
end
