class PageTodosController < ApplicationController

  before_action :authenticate_user!

  def create
    @page_todo = PageTodo.new(page_todo_params)
    @page = @page_todo.page
    if @page_todo.save
      redirect_to edit_write_account_site_story_path(@account, @site, @page, folder_id: @page.folder_id), notice: t("cs")
    else
      @ref_intersection = RefCategory.where(site_id: @site.id, genre: "intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
      @ref_sub_intersection = RefCategory.where(site_id: @site.id, genre: "sub intersection", is_disabled: [false, nil]).order(:name).map {|r| ["#{r.name}", r.id]}
      @template_cards = @account.template_cards.where(is_current_version: true)
      @page_todos = @page.page_todos.order(:sort_order)
      render "stories/edit_write"
    end
  end

  def destroy
    @page_todo = PageTodo.find(params[:id])
    @page = @page_todo.page
    @page_todo.destroy
    redirect_to edit_write_account_site_story_path(@account, @site, @page, folder_id: @page.folder_id), notice: t("ds")
  end

  def complete
    @page_todo = PageTodo.find(params[:id])
    @page = @page_todo.page
    @page_todo.update_attributes(is_completed: !@page_todo.is_completed)
    redirect_to edit_write_account_site_story_path(@account, @site, @page, folder_id: @page.folder_id), notice: t("ds")
  end

  private

    def page_todo_params
      params.require(:page_todo).permit(:page_id, :user_id, :template_card_id, :task, :is_completed, :sort_order, :created_by, :updated_by)
    end
end
