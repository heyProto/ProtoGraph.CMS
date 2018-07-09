class TemplatePagesController < ApplicationController
  
  def index
    @template_pages = TemplatePage.all.order("updated_at desc")
  end

  def show
    @template_page = TemplatePage.friendly.find(params[:id])
  end

end
