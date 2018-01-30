class SiteVerticalNavigationsController < ApplicationController

  before_action :authenticate_user!, :set_ref_category
  before_action :set_site_vertical_navigation, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

  def index
    @site_vertical_navigations = @ref_category.navigations
    @site_vertical_navigation = SiteVerticalNavigation.new
  end

  def create
    @site_vertical_navigation = SiteVerticalNavigation.new(site_vertical_navigation_params)
    @site_vertical_navigation.created_by = current_user.id
    @site_vertical_navigation.updated_by = current_user.id
    if @site_vertical_navigation.save
      redirect_to account_site_ref_category_site_vertical_navigations_path(@account, @site, @ref_category), notice: t('cs')
    else
      @site_vertical_navigations = @ref_category.navigations
      render :index
    end
  end

  def move_up
    @site_vertical_navigation.update_attributes(updated_by: current_user.id, sort_order: @site_vertical_navigation.sort_order - 1)
    redirect_to account_site_ref_category_site_vertical_navigations_path(@account, @site, @ref_category), notice: t('us')
  end

  def move_down
    @site_vertical_navigation.update_attributes(updated_by: current_user.id, sort_order: @site_vertical_navigation.sort_order + 1)
    redirect_to account_site_ref_category_site_vertical_navigations_path(@account, @site, @ref_category), notice: t('us')
  end

  def update
    @site_vertical_navigation.updated_by = current_user.id
    if @site_vertical_navigation.update(site_vertical_navigation_params)
      redirect_to account_site_ref_category_site_vertical_navigations_path(@account, @site, @ref_category), notice: t('us')
    else
      @site_vertical_navigations = @ref_category.navigations
      render :index
    end
  end

  def destroy
    @site_vertical_navigation.destroy
    redirect_to account_site_ref_category_site_vertical_navigations_path(@account, @site, @ref_category), notice: t('ds')
  end

  private

    def set_site_vertical_navigation
      @site_vertical_navigation = SiteVerticalNavigation.find(params[:id])
    end

    def set_ref_category
      @ref_category = RefCategory.friendly.find(params[:ref_category_id])
    end

    def site_vertical_navigation_params
      params.require(:site_vertical_navigation).permit(:site_id, :ref_category_vertical_id, :name, :url, :launch_in_new_window, :created_by, :updated_by, :sort_order)
    end
end
