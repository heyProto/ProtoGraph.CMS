class RefLinkSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :authentication_user_can_publish
  before_action :set_ref_link_source, only: [:destroy]

  def index
    @ref_link_sources = RefLinkSource.all
    @ref_link_source = RefLinkSource.new
  end

  def create
    @ref_link_source = RefLinkSource.new(ref_link_source_params)
    @ref_link_source.creator = current_user
    @ref_link_source.updator = current_user
    if @ref_link_source.save
      redirect_to ref_link_sources_path, notice: t('cs')
    else
      @ref_link_sources = RefLinkSource.all
      flash.now.alert = t('cf')
      render "index"
    end
  end

  def publish
    if RefLinkSource.publish
      redirect_to ref_link_sources_path, notice: t("publish.ref_link_sources")
    else
      redirect_to ref_link_sources_path, alert: t("publish.failure")
    end
  end

  def destroy
    @ref_link_source.destroy
    redirect_to ref_link_sources_path, notice: t("ds")
  end

  private

  def authentication_user_can_publish
    unless current_user.can_publish_link_sources
      redirect_back(fallback_location: root_path)
    end
  end

  def ref_link_source_params
    params.require(:ref_link_source).permit(:name, :url, :favicon_url)
  end

  def set_ref_link_source
    @ref_link_source = RefLinkSource.find(params[:id])
  end
end
