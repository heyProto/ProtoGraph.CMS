class AudioVariationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @audio_variation = AudioVariation.new(audio_variation_params)
    @audio_variation.is_original = false
    @audio_variation.creator = current_user
    @audio_variation.updator = current_user
    if @audio_variation.save
      track_activity(@audio_variation)
      redirect_to account_audio_path(@account, @audio_variation.audio), notice: "Audio Variation added successfully"
    else
      redirect_to account_audio_path(@account, @audio_variation.audio), alert: "Failed to create audio variation"
    end
  end

  private

  def set_audio_variation
    @audio_variation = AudioVariation.find(params[:id])
  end


  def audio_variation_params
    params.require(:audio_variation).permit(:audio_id, :start_time, :end_time)
  end

end
