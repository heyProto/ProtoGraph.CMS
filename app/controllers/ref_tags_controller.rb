class RefTagsController < ApplicationController

  before_action :authenticate_user!
  before_action :sudo_role_can_add_site_tags, only: [:edit, :update]
  before_action :set_entity, only: [ :update, :destroy, :disable]

  def update
    respond_to do |format|
      if @ref_tag.update_attributes(entity_params)
        @notice = 'Updated successfully.'
        format.json { respond_with_bip(@ref_tag) }
        format.html { redirect_to tag_account_site_path(@account, @site), notice: "Updated" }
      else
        format.json { respond_with_bip(@ref_tag) }
        format.html { render :action => "edit" }
      end
    end
  end

  def disable
    @ref_tag.update_attributes(is_disabled: true, updated_by: current_user.id)
    @notice = 'Ref tags was successfully disabled.'
    redirect_to tag_account_site_path(@account, @site)
  end

  def destroy
    @ref_tag.destroy
    respond_to do |format|
        format.html { redirect_to tag_account_site_path(@account, @site), notice: "Destroyed"}
    end
  end

  private

    def set_entity
        @ref_tag = RefTag.find(params[:id])
    end

    def entity_params
        params.require(:ref_tag).permit(:site_id, :genre, :name, :is_disabled, :created_by, :updated_by)
    end
end
