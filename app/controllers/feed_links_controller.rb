class FeedLinksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_ref_category, :set_feed_link

  #Create view_cast
  #Enter the view_cast in feed_links table
  #Add this view_cast to FEEDS stream
  #Return back to http://localhost:3000/accounts/moiz/sites/moiz/ref_categories/abcd/feeds
  def create_view_cast
    @feed_link.temp_headline = feeds_params[:temp_headline]
    unless @feed_link.view_cast_id.present?
      @feed_link.create_or_update_view_cast
    end
    redirect_to account_site_ref_category_feeds_path(@account, @site, @ref_category), notice: "Link will be added tot feed shortly"
  end

  private

    def set_ref_category
      @ref_category = RefCategory.friendly.find(params[:ref_category_id])
    end

    def set_feed_link
      @feed_link = FeedLink.find(params[:id])
    end

    def feeds_params
      params.require(:feed_link).permit(:ref_category_id, :link, :headline, :published_at, :description, :cover_image, :author, :temp_headline)
    end


end
