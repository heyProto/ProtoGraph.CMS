# == Schema Information
#
# Table name: services_attachables
#
#  id                 :integer          not null, primary key
#  account_id         :integer
#  attachable_id      :integer
#  attachable_type    :string(255)
#  genre              :string(255)
#  file_url           :text(65535)
#  original_file_name :text(65535)
#  file_type          :string(255)
#  s3_bucket          :string(255)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ServicesAttachable < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    mount_uploader :file_url, ServiceAttachableUploader

    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    #belongs_to :attachable, polymorphic: true

    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    before_save :before_save_set

    #SCOPE
    #OTHER

    def self.create_shell_object(o, gen)
        ServicesAttachable.create(attachable_id: o.id, attachable_type: o.class.to_s, genre: gen, account_id: o.account_id, created_by: o.created_by, updated_by: o.updated_by)
    end

    #PRIVATE
    private

    def before_save_set
        if self.file_url_changed? and self.file_url.present?
            self.original_file_name = self.file_url.file.methods.include?(:original_filename) ? self.file_url.file.original_filename : nil
            self.s3_bucket = ENV.fetch("AWS_S3_BUCKET")
            true
        end
    end

end
