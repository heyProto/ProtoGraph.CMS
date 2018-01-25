class AudiosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_audio, only: [:show]

  def index
    @q = @account.audios.ransack(params[:q])
    if params[:q].present?
      @audios = @q.result(distinct: true).order(:created_at).page params[:page]
    else
      @audios = @account.audios.order("created_at DESC").page params[:page]
    end
    @new_audio = Audio.new
    render layout: "application-fluid"
  end

  def create
    @audio = Audio.new(audio_params)
    @audio.creator = current_user
    @audio.updator = current_user
    respond_to do |format|
      if @audio.save
        track_activity(@audio)
        format.json { render json: {success: true, data: @audio}, status: 200 }
        format.html { redirect_to account_audios_path(@account), notice: 'Audio added successfully' }
      else
        format.json { render json: {success: false, errors: @audio.errors.full_messages }, status: 400 }
        format.html { redirect_to account_audios_path(@account), alert: @audio.errors.full_messages }
      end
    end
  end

  def show
    @new_audio = Audio.new
    @audio_variation = AudioVariation.new
    render layout: "application-fluid"
    @activities = @audio.activities.order("updated_at DESC").limit(30)
    @audio_variation = AudioVariation.new
  end

  private

  def set_audio
    @audio = @account.audios.find(params[:id])
  end

  def audio_params
    params.require(:audio).permit(:account_id, :audio, :name, :description, :total_time)
  end
end
