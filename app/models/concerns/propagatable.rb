module Propagatable
    extend ActiveSupport::Concern
    
    included do
      after_commit :propogate_updated_at
    end
    
    private
    
    def propogate_updated_at
      if self.class.to_s == "UserEmail" or (self.class.to_s == "Authentication" and self.user_id.present?)
        if self.saved_changes.present?
          self.user.updated_at = Time.now
        end
      end
      true
    end
    
end