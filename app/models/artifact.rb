class Artifact < ApplicationRecord

  before_save :upload_to_s3
  attr_accessor :upload
  belongs_to :project

  MAX_FILE_SIZE = 10.megabytes
  validates_presence_of :name, :upload
  validates_uniqueness_of :name
  
  validate :uploaded_file_size

  private

  def upload_to_s3
    bucket_name_file = File.open("/home/srlane/Notes/aws-bucket-name")
    bucket_name = bucket_name_file.read

    access_file = File.open("/home/srlane/Notes/aws-access")
    access_key = access_file.read
    
    secret_file = File.open("/home/srlane/Notes/aws-secret")
    secret_key = secret_file.read
    
    s3 = Aws::S3::Resource.new(region: 'us-east-2', access_key_id: access_key, secret_access_key: secret_key)
    tenant_name = Tenant.find(Thread.current[:tenant_id]).name
    obj = s3.bucket(bucket_name).object("#{tenant_name}/#{upload.original_filename}")
    obj.upload_file(upload.path, acl:'public-read')
    self.key = obj.public_url
  end

  def uploaded_file_size
    if upload
      errors.add(:upload, "File size must be less that #{self.class::MAX_FILE_SIZE}") unless upload.size <= self.class::MAX_FILE_SIZE
    end
  end

end
