require "aws-sdk-s3"

class CfAppDiscovery
  class S3Manager
    attr_accessor :bucket

    def initialize(bucket_name:)
      self.bucket = Aws::S3::Bucket.new(bucket_name)
    end

    def filenames(path:)
      bucket.objects(prefix: path)
    end

    def exist?(filename)
      bucket.object(filename).exists?
    end

    def read(filename)
      bucket.object(filename).get.body
    end

    def write(content, filename)
      bucket.put_object(body: content, key: filename)
    end

    def remove(*filenames)
      objects = filenames.map do |filename|
        { key: filename }
      end

      bucket.delete_objects(delete: { objects: objects })
    end

    def move(old_filename, new_filename)
      bucket.object(old_filename).move_to(bucket: bucket.name, key: new_filename)
    end
  end
end
