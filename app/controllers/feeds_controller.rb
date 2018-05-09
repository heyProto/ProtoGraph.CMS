class FeedsController < ApplicationController
  
  before_action :set_ref_category

  def index
    @feeds = @ref_category.feeds
    @feed_links = FeedLink.where("view_cast_id IS NULL").where(feed_id: @feeds.pluck(:id).uniq).order("published_at DESC")
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.created_by = current_user.id
    @feed.updated_by = current_user.id
    if @feed.save
      FeedsWorker.perform(@feed.ref_category_id, @feed.id)
      redirect_to account_site_ref_category_feeds_path(@account, @site, @ref_category), notice: 'Ref category feed was successfully created.'
    else
      @feeds = @ref_category.feeds
      render :index
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    redirect_to account_site_ref_category_feeds_path(@account, @site, @ref_category), notice: 'Ref category feed was successfully destroyed.'
  end

  private

    def set_ref_category
      @ref_category = RefCategory.friendly.find(params[:ref_category_id])
    end

    def feed_params
      params.require(:feed).permit(:ref_category_id, :rss, :last_updated_at)
    end
end
