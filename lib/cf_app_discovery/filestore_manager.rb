require "aws-sdk-s3"

class CfAppDiscovery
  class FilestoreManager
    def initialize(bucket_name:)
      @bucket = Aws::S3::Bucket.new(bucket_name)
    end
    def filenames(path:)
      @bucket.objects({prefix: path})
    end
  end
end
