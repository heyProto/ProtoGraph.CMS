class FeedsController < ApplicationController
  
  before_action :set_ref_category

  def create_view_cast
  end

  private

    def set_ref_category
      @ref_category = RefCategory.friendly.find(params[:ref_category_id])
    end

end
