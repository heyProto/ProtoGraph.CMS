class TemplateStreamsController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_template_designer
  before_action :sudo_pykih_admin, except: [:index, :show]
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
    @prev_version = TemplateStream.friendly.find(params[:id]) if params[:id].present?
    if @prev_version.present?
      @template_stream.previous_version_id = params[:id]
      @template_stream.deep_copy
    end
  end

  def create
    @template_stream = TemplateStream.new(template_stream_params)
    @template_stream.created_by = current_user.id
    @template_stream.updated_by = current_user.id
    if @template_stream.save
      redirect_to [@account, @template_stream], notice: t("cs")
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
      params.require(:template_stream).permit(:account_id, :name, :elevator_pitch, :description, :global_slug, :is_current_version, :version_series, :previous_version_id, :version_genre, :version, :change_log, :status, :publish_count, :is_public, :created_by, :updated_by)
    end
end
