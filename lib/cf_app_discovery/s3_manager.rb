require "aws-sdk-s3"

class CfAppDiscovery
  class S3Manager
    attr_accessor :bucket

    def initialize(bucket_name:)
      bucket = Aws::S3::Bucket.new(bucket_name)
    end

    def filenames(path:)
      bucket.objects({ prefix: path })
    end

    def exist?(path)
      bucket.object(path).exists?
    end

    def read(path)
      bucket.object(path).get.body
    end

    def write(content, path)
      bucket.put_object(body: content, key: path)
    end
  end
end
