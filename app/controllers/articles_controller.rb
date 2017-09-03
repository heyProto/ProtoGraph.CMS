class ArticlesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article, only: [:show, :edit, :update, :publish]

    def index
        @articles = @folder.articles
    end

    def create
        a_params = article_params
        a_params["cover_image_attributes"]["name"] = a_params["title"]
        a_params["cover_image_attributes"]["description"] = a_params["summary"]
        a_params["cover_image_attributes"]["tag_list"] = [a_params["genre"]]
        a_params["cover_image_attributes"]["account_id"] = @account.id
        a_params["cover_image_attributes"]["created_by"] = current_user.id
        a_params["cover_image_attributes"]["updated_by"] = current_user.id
        @article = @folder.articles.new(a_params)
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
        params.require(:article).permit(:account_id, :folder_id, :title, :summary, :content, :genre, :url, :created_by, :updated_by, cover_image_attributes: [:image])
    end

    def set_article
        @article = @folder.articles.friendly.find(params[:id])
    end
end