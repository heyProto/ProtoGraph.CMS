module AssociableSite
    extend ActiveSupport::Concern

    included do
        belongs_to :account, optional: true
        belongs_to :site, optional: true
    end
    
end