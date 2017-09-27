class ArticlesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article, only: [:show, :edit, :update, :remove_cover_image,:remove_twitter_image, :remove_facebook_image, :remove_instagram_image, :publish_card]
    layout "application-fluid"

    def index
      @view_casts_count = @folder.view_casts.count
      @streams_count = @folder.streams.count
      @articles_count = @folder.articles.count
      @articles = @folder.articles.order(updated_at: :desc).page(params[:page]).per(30)
    end

    def create
        a_params = article_params
        if a_params.has_key?("cover_image_attributes") and a_params["cover_image_attributes"].has_key?("image")
            a_params["cover_image_attributes"]["name"] = article_params["cover_image_attributes"]['image'].original_filename
            a_params["cover_image_attributes"]["description"] = a_params["summary"]
            a_params["cover_image_attributes"]["tag_list"] = [a_params["genre"]]
            a_params["cover_image_attributes"]["account_id"] = @account.id
            a_params["cover_image_attributes"]["created_by"] = current_user.id
            a_params["cover_image_attributes"]["updated_by"] = current_user.id
        end
        @article = @folder.articles.new(a_params)
        @article.created_by = current_user.id
        @article.updated_by = current_user.id
        if @article.save
            track_activity(@article)
            redirect_to edit_account_folder_article_path(@account, @article.folder, @article), notice: t('cs')
        else
            flash.now.alert = @article.errors.full_messages
            @article.build_cover_image
            @view_casts_count = @folder.view_casts.count
            @streams_count = @folder.streams.count
            @articles_count = @folder.articles.count
            @is_viewcasts_present = @view_casts_count != 0
            render :new
        end
    end

    def new
        redirect_to [@account, @folder], alert: "Cannot create an article without logo image" if @account.logo_image_id.nil?
        @article = @folder.articles.new
        @article.build_cover_image
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
        @is_viewcasts_present = @view_casts_count != 0
    end

    def show
    end

    def edit
        @image = @article.cover_image
        if @image.blank?
            @article.build_cover_image
        else
            @image_variation = @image_variation = ImageVariation.new
        end
        @view_casts_count = @folder.view_casts.count
        @streams_count = @folder.streams.count
        @articles_count = @folder.articles.count
        @article_modes = ""
        @article.cover_image.id.present? ? (@article_modes << "1") : (@article_modes << "0")
        @article.content.present? ? (@article_modes << "1") : (@article_modes << "0")
        @folders = @account.folders
    end

    def update
        a_params = article_params
        if a_params.has_key?("cover_image_attributes") and a_params["cover_image_attributes"].has_key?("image")
            a_params["cover_image_attributes"]["name"] = article_params["cover_image_attributes"]['image'].original_filename
            a_params["cover_image_attributes"]["description"] = a_params["summary"]
            a_params["cover_image_attributes"]["account_id"] = @account.id
            a_params["cover_image_attributes"]["created_by"] = current_user.id
            a_params["cover_image_attributes"]["updated_by"] = current_user.id
        end

        respond_to do |format|
            if @article.update(a_params)
                track_activity(@article)
                format.html {
                    @article.reload
                    redirect_to(edit_account_folder_article_path(@account, @article.folder, @article), notice: t('us'))
                }
                format.json { respond_with_bip(@article) }
            else
                format.html {
                    @image = @article.cover_image
                    if @image.blank?
                        @article.build_cover_image
                    else
                        @image_variation = @image_variation = ImageVariation.new
                    end
                    @view_casts_count = @folder.view_casts.count
                    @streams_count = @folder.streams.count
                    @articles_count = @folder.articles.count
                    @article_modes = ""
                    @article.cover_image.id.present? ? (@article_modes << "1") : (@article_modes << "0")
                    @article.content.present? ? (@article_modes << "1") : (@article_modes << "0")
                    @folders = @account.folders
                    render :edit
                }
                format.json { respond_with_bip(@article) }
            end
        end
    end

    def remove_cover_image
        case action_name
        when "remove_facebook_image"
            @article.update_attribute(:og_image_variation_id, nil)
        when "remove_twitter_image"
            @article.update_attribute(:twitter_image_variation_id, nil)
        when "remove_instagram_image"
            @article.update_attribute(:instagram_image_variation_id, nil)
        else
            @article.update_attribute(:cover_image_id, nil)
        end
        redirect_to edit_account_folder_article_path(@account, @article.folder, @article), notice: t("ds")
    end

    [:remove_twitter_image, :remove_facebook_image, :remove_instagram_image].each do |meth|
        alias_method meth, :remove_cover_image
    end

    private

    def article_params
        params.require(:article).permit(:account_id, :folder_id, :title, :summary, :content, :genre, :url, :created_by, :updated_by, :og_image_variation_id, :twitter_image_variation_id, :instagram_image_variation_id, :cover_image_id, :author, :article_datetime, cover_image_attributes: [:image])
    end

    def set_article
        @article = @folder.articles.friendly.find(params[:id])
    end
end