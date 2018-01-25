module Associable
    extend ActiveSupport::Concern

    included do
        belongs_to :account, optional: true
        belongs_to :creator, class_name: "User", foreign_key: "created_by", optional: true
        belongs_to :updator, class_name: "User", foreign_key: "updated_by", optional: true
    end
end