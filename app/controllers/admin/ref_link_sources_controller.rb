class Admin::RefLinkSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :sudo_pykih_admin
  before_action :set_ref_link_source, only: [:edit, :update]

  def index
    @ref_link_sources = RefLinkSource.all
  end

  def new
    @ref_link_source = RefLinkSource.new
  end

  def create
    @ref_link_source = RefLinkSource.new(ref_link_source_params)
    @ref_link_source.creator = current_user
    @ref_link_source.updator = current_user
    if @ref_link_source.save
      redirect_to admin_ref_link_sources_path, notice: "Link Source created succesfully"      
    else
      redirect_to admin_ref_link_sources_path, alert: "Link Source could not be created"      
    end
  end

  def update
    @ref_link_source.update(ref_link_source_params)
    @ref_link_source.updator = current_user
    if @ref_link_source.save
      redirect_to admin_ref_link_sources_path, notice: "Link Source updated succesfully"      
    else
      redirect_to admin_ref_link_sources_path, alert: "Link Source could not be updated"      
    end
  end

  def edit
  end

  def publish
    if RefLinkSource.publish
      redirect_to admin_ref_link_sources_path, notice: "Link Sources published succesfully"
    else
      redirect_to admin_ref_link_sources_path, notice: "Link Sources could not be published"
    end
  end

  private

  def ref_link_source_params
    params.require(:ref_link_source).permit(:name, :url, :favicon_url)
  end

  def set_ref_link_source
    @ref_link_source = RefLinkSource.find(params[:id])
  end
end
