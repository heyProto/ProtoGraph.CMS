class TemplateStreamsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :set_template_stream, only: [:show, :edit, :update, :destroy, :flip_public_private, :move_to_next_status]

  def index
    @template_streams = @account.template_streams
  end

  def show
    @template_cards = @template_stream.template_cards
  end

  def flip_public_private
    redirect_to account_template_stream_path(@account, @template_stream), notice: @template_stream.flip_public_private
  end

  def move_to_next_status
    redirect_to account_template_stream_path(@account, @template_stream), notice: @template_stream.move_to_next_status
  end

  def new
    @template_stream = TemplateStream.new
  end

  def create
    @template_stream.created_by = current_user.id
    @template_stream.updated_by = current_user.id
    @template_stream = TemplateStream.new(template_stream_params)
    if @template_stream.save
      redirect_to @template_stream, notice: t("cs")
    else
      render :new
    end
  end

  def update
    @template_stream.status = "Draft"
    @template_stream.updated_by = current_user.id
    respond_to do |format|
      if @template_stream.update(template_stream_params)
        format.js {respond_with_bip(@template_stream) }
        format.json { respond_with_bip(@template_stream) }
      else
        format.js {respond_with_bip(@template_stream) }
        format.json { respond_with_bip(@template_stream) }
      end
    end
  end

  def destroy
    if !@template_stream.streams.first.present?
      @template_stream.destroy
      redirect_to account_template_streams_path(@account), notice: t("ds")
    else
      @template_stream.update_attributes(status: "Deactivated")
      redirect_to account_template_stream_path(@account, @template_stream), notice: t("ds")
    end
  end

  private

    def set_template_stream
      @template_stream = TemplateStream.friendly.find(params[:id])
    end

    def template_stream_params
      params.require(:template_stream).permit(:account_id, :name, :description, :slug, :status, :publish_count, :created_by, :updated_by, :is_public)
    end
end
