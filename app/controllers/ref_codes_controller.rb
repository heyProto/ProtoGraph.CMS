class RefCodesController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_account_settings
  before_action :set_ref_code, only: [:show, :edit, :update, :destroy]

  def index
    @ref_codes = @account.ref_codes
    @ref_code = RefCode.new
    @people_count = @account.users.count
  end

  def create
    @ref_code = RefCode.new(ref_code_params)
    if @ref_code.save
      redirect_to account_ref_codes_path(@account), notice: "Successfully added."
    else
      @ref_codes = @account.ref_codes
      @people_count = @account.users.count
      render :index
    end
  end

  def destroy
    @ref_code.destroy
    redirect_to account_ref_codes_path(@account), notice: "Successfully deleted."
  end

  private

    def set_ref_code
      @ref_code = RefCode.find(params[:id])
    end

    def ref_code_params
      params.require(:ref_code).permit(:account_id, :key, :val, :is_default, :sort_order, :created_by, :updated_by)
    end
end
