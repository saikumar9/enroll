module TransportGateway
  class Adapters::Aws3Adapter

    ACL_KINDS = [:private, :public_read, :public_read_write, :authenticated_read, :log_delivery_write]


    # URI form: aws3:://[region:]site@bucket_name/object_collection/object_name

    # aws3://us-west-1:cca@aca_shop.admin/reports/20170804/

    # aws3://cca@aca_shop.admin/reports/20170804/
    # aws3://cca@aca_shop.admin/reports/20170805/
    # aws3://dchbx@aca_individual.admin/reports/20170805/

    # aws3://cca@aca_shop.<employers|broker_agencies|general_agencies|carriers>/<hbx_id>
    # aws3://cca@aca_shop.employers/<hbx_id>/documents/attestations/
    # aws3://cca@aca_shop.employers/<hbx_id>/documents/invoices/
    # aws3://cca@aca_shop.employers/<hbx_id>/documents/notices/

    # aws3://cca@insured.families/<hbx_id>/documents/notices/
    # aws3://cca@insured.families/<hbx_id>/documents/1095as/
    # aws3://cca@insured.person/<hbx_id>/documents/vlp/

    def initialize
    end

    def send_message(message)
      s3 = AWS::S3.new
      obj = s3.buckets['my-bucket'].objects['key']

      bucket.exists? ? @bucket = bucket : @bucket = create_bucket(bucket_name)
    end


  private
    def create_bucket(new_bucket_name)
      @bucket = @s3.create(new_bucket_name, access_options)
    end

    def access_options
      {
          location_constraint: "",
          acl: "",
          grant_read: "",
          grant_write: "",
          grant_read_acp: "",
          grant_write_acp: "",
          grant_full_control: "",
        }
    end

  end
end
