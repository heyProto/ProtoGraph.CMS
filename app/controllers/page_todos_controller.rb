class PageTodosController < ApplicationController
  before_action :set_page_todo, only: [:show, :edit, :update, :destroy]

  def index
    @page_todos = PageTodo.all
  end

  def show
  end

  def new
    @page_todo = PageTodo.new
  end

  def edit
  end

  def create
    @page_todo = PageTodo.new(page_todo_params)

    respond_to do |format|
      if @page_todo.save
        format.html { redirect_to @page_todo, notice: 'Page todo was successfully created.' }
        format.json { render :show, status: :created, location: @page_todo }
      else
        format.html { render :new }
        format.json { render json: @page_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @page_todo.update(page_todo_params)
        format.html { redirect_to @page_todo, notice: 'Page todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_todo }
      else
        format.html { render :edit }
        format.json { render json: @page_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @page_todo.destroy
    respond_to do |format|
      format.html { redirect_to page_todos_url, notice: 'Page todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_page_todo
      @page_todo = PageTodo.find(params[:id])
    end

    def page_todo_params
      params.require(:page_todo).permit(:page_id, :user_id, :template_card_id, :task, :is_completed, :sort_order, :created_by, :updated_by)
    end
end
