class TemplateStreamsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_template_stream, only: [:show, :edit, :update, :destroy]

  def index
    @template_streams = @account.template_streams
  end

  def show
  end

  def new
    @template_stream = TemplateStream.new
  end

  def edit
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
    @template_stream.updated_by = current_user.id
    respond_to do |format|
      if @template_stream.update(template_stream_params)
        format.html { redirect_to @template_stream, notice: t("us") }
        format.js{ respond_with_bip(@template_stream) }
        format.json { render :show, status: :ok, location: @template_stream }
      else
        format.html { render :edit }
        format.js {respond_with_bip(@template_stream)}
        format.json { render json: @template_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @template_stream.destroy
    redirect_to template_streams_url, notice: t("ds")
  end

  private

    def set_template_stream
      @template_stream = TemplateStream.friendly.find(params[:id])
    end

    def template_stream_params
      params.require(:template_stream).permit(:account_id, :name, :description, :slug, :status, :publish_count, :created_by, :updated_by)
    end
end
