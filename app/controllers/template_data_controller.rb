class TemplateDataController < ApplicationController

  before_action :authenticate_user!, :sudo_pykih_admin
  before_action :set_template_datum, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_data = @account.template_data
  end

  def show
    @template_cards = @template_datum.template_cards
  end

  def flip_public_private
    if @template_datum.is_public
      if @template_datum.can_make_private?
        @template_datum.update_attributes(is_public: false)
        notice = "Successfully done."
      else
        notice = "Failed. Some other account is using a card associated with this data."
      end
    else
      if @template_datum.can_make_public?
        @template_datum.update_attributes(is_public: true)
        notice = "Successfully done."
      else
        notice = "Failed. Make sure data is published."
      end
    end
    redirect_to account_template_datum_path(@account, @template_datum), notice: notice
  end

  def move_to_next_status
    if @template_datum.can_ready_to_publish?
      @template_datum.update_attributes(status: "Ready to Publish")
      notice = "Successfully updated."
    elsif @template_datum.status == "Ready to Publish"
      @template_datum.update_attributes(status: "Published")
      notice = "Successfully updated."
    else
      notice = "Failed."
    end
    redirect_to account_template_datum_path(@account, @template_datum), notice: notice
  end

  def new
    @template_datum = TemplateDatum.new
  end

  def create
    @template_datum = TemplateDatum.new(template_datum_params)
    @template_datum.created_by = current_user.id
    @template_datum.updated_by = current_user.id
    if @template_datum.save
      redirect_to [@account, @template_datum], notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_datum.status = "Draft"
    @template_datum.updated_by = current_user.id
    respond_to do |format|
      if @template_datum.update(template_datum_params)
        format.js {respond_with_bip(@template_datum) }
        format.json { respond_with_bip(@template_datum) }
      else
        format.js {respond_with_bip(@template_datum)}
        format.json {respond_with_bip(@template_datum)}
      end
    end
  end

  def destroy
    @template_datum.destroy
    redirect_to template_data_url, notice: t("ds")
  end

  def destroy
    if @template_datum.can_delete?
      @template_datum.destroy
      redirect_to account_template_data_path(@account), notice: t("ds")
    else
      @template_datum.update_attributes(status: "Deactivated")
      redirect_to account_template_datum_path(@account, @template_datum), notice: t("ds")
    end
  end

  private

    def set_template_datum
      @template_datum = TemplateDatum.friendly.find(params[:id])
    end

    def template_datum_params
      params.require(:template_datum).permit(:account_id, :name, :description, :slug, :status, :api_key, :publish_count, :created_by, :updated_by, :is_public)
    end
end
