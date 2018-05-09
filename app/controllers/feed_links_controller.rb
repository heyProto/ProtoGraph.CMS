class FeedsController < ApplicationController
  
  before_action :set_ref_category

  def create_view_cast
    #Create view_cast
    #Enter the view_cast in feed_links table
    #Add this view_cast to FEEDS stream
    #Return back to http://localhost:3000/accounts/moiz/sites/moiz/ref_categories/abcd/feeds
  end

  private

    def set_ref_category
      @ref_category = RefCategory.friendly.find(params[:ref_category_id])
    end

end
