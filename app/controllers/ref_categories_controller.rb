class RefCategoriesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :sudo_role_can_account_settings, only: [:edit, :update]
  before_action :set_ref_category, only: [:show, :edit, :update, :destroy]

  def index
    @all_series = RefCategory.where(category: "series")
    @all_intersections = RefCategory.where(category: "intersections")
    @all_sub_intersections = RefCategory.where(category: "sub_intersections")
    @series = RefCategory.new
    @intersection = RefCategory.new
    @sub_intersection = RefCategory.new
  end

  def create
    @ref_category = RefCategory.new(ref_category_params)
    @ref_category.created_by = current_user.id
    @ref_category.updated_by = current_user.id
      if @ref_category.save
        redirect_to account_site_ref_categories_path(@account, @site), notice: 'Ref category was successfully created.'
      else
        render :index
      end
  end

  def destroy
    @ref_category.update_attributes(is_disabled: true, updated_by: current_user.id)
    redirect_to account_site_ref_categories_path(@account, @site), notice: 'Ref category was successfully destroyed.'
  end

  private

    def set_ref_category
      @ref_category = RefCategory.find(params[:id])
    end

    def ref_category_params
      params.require(:ref_category).permit(:site_id, :category, :name, :is_disabled, :created_by, :updated_by)
    end
end
