class ArticlesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article, only: [:show, :edit, :update, :publish]

    def index
        @articles = @folder.articles
    end

    def create
        @article = @folder.articles.new(article_params)
        @article.created_by = current_user.id
        @article.updated_by = current_user.id
        if @article.save
            redirect_to account_folder_article_path(@account, @folder, @article), notice: t('cs')
        else
            render :new
        end
    end

    def new
        @article = @folder.articles.new
        @article.build_cover_image
    end

    def show
    end

    def update
        if @article.update(articles_params)
            redirect_to account_folder_article_path(@account, @folder, @article), notice: t('cs')
        else
            render :edit
        end
    end

    private

    def article_params
        params.require(:article).permit(:account_id, :folder_id, :title, :summary, :content, :genre, :url, :created_by, :updated_by, cover_image: [:image])
    end

    def set_article
        @article = @folder.articles.friendly.find(params[:id])
    end
end