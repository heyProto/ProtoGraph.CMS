# == Schema rnformation
#
# Table name: streams
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  slug                   :string(255)
#  description            :text(65535)
#  folder_id              :integer
#  account_id             :integer
#  datacast_identifier    :string(255)
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  card_count             :integer
#  last_published_at      :datetime
#  order_by_key           :string(255)
#  order_by_value         :string(255)
#  limit                  :integer
#  offset                 :integer
#  is_grouped_data_stream :boolean          default(FALSE)
#  data_group_key         :string(255)
#  filter_query           :text(65535)
#  data_group_value       :string(255)
#  site_id                :integer
#  include_data           :boolean          default(FALSE)
#  is_automated_stream    :boolean          default(FALSE)
#  col_name               :string(255)
#  col_id                 :integer
#  order_by_type          :string(255)
#  is_open                :boolean
#

class Stream < ApplicationRecord
    #CONSTANTS
    CARD_KEYS = {
        "toRainfall": ["rainfall_deficit_score", "district"],
        "toLandUse": ["land_score", "forest_score", "population_score"],
        "toWaterExploitation": ["decadal_decrease_score"],
        "toWell": ["well_score"]
    }

    #GEMS
    extend FriendlyId
    friendly_id :title, use: :slugged
    #CONCERNS
    include Propagatable
    include AssociableByAcSiFo
    #ASSOCIATIONS
    has_many :folder_ids, ->{folders}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :template_card_ids, ->{template_cards}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :view_cast_ids, ->{view_casts}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :excluded_view_cast_ids, ->{excluded_view_casts}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :permissions, ->{where(status: "Active", permissible_type: 'Stream')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :users, through: :permissions
    has_many :page_streams
    has_many :pages, through: :page_streams
    has_many :stream_entities
    has_many :ad_integrations

    #ACCESSORS
    attr_accessor :folder_list
    attr_accessor :card_list #Template Card list
    attr_accessor :view_cast_id_list
    attr_accessor :excluded_view_cast_id_list
    attr_accessor :collaborator_lists
    #VALIDATIONS
    validates :data_group_key, presence: true, if: :is_grouped_data_stream
    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set
    after_save :after_save_set
    after_save :update_card_count
    before_destroy :before_destroy_set

    #SCOPE
    #OTHER

    def cards(apply_limit=true)
        if is_automated_stream
            if col_name == "Site"
                site = Site.find(col_id)
                view_casts = site.view_casts.where.not(folder_id: account.folders.where(is_trash: true).pluck(:id)).where(template_card_id: TemplateCard.where(name: "toStory").pluck(:id)).limit(self.limit).offset(self.offset).order("published_at::date DESC")
            elsif col_name == "RefCategory"
                ref_cat = RefCategory.find(col_id)
                view_casts = ref_cat.view_casts.where.not(folder_id: account.folders.where(is_trash: true).pluck(:id)).limit(self.limit).offset(self.offset).order("published_at::date DESC")
            elsif col_name == 'Permission'
                permission = Permission.find(col_id)
                view_casts = permission.view_casts.where.not(folder_id: account.folders.where(is_trash: true).pluck(:id)).limit(self.limit).offset(self.offset).order("published_at::date DESC")
            else
                view_casts = ViewCast.none
            end
            return view_casts
        else
            query = {}
            query[:folder_id] = self.folder_ids.pluck(:entity_value) if self.folder_ids.count > 0
            query[:template_card_id] = self.template_card_ids.pluck(:entity_value) if self.template_card_ids.count > 0
            unless query.blank?
                view_cast = account.view_casts.order(created_at: :desc).where(query).where.not(folder_id: account.folders.where(is_trash: true).first.id)
                view_cast = view_cast.where.not(id: self.excluded_view_cast_ids.pluck(:entity_value)) if self.excluded_view_cast_ids.count > 0
                view_cast = view_cast.limit(self.limit).offset(self.offset) if apply_limit
            else
                view_cast = ViewCast.none
            end
            vc_ids = self.view_cast_ids.order(:sort_order).pluck(:entity_value)
            view_cast_or = vc_ids.present? ? account.view_casts.where(id: vc_ids).where.not(folder_id: account.folders.where(is_trash: true).first.id) : ViewCast.none
            if self.title.split("_")[1] == "Section"
                view_cast_or = view_cast_or.order("published_at::date DESC")
            elsif vc_ids.present?
                view_cast_or = view_cast_or.order("array_position(Array[#{vc_ids.join(",")}], id::integer)")
            end
            if view_cast.present? and view_cast_or.present?
                return view_cast + view_cast_or
            elsif view_cast.blank? and view_cast_or.present?
                return view_cast_or
            else
                return view_cast
            end
        end
    end

    def publish_cards
        cards_json = []
        if self.is_grouped_data_stream
            district_obj = {}
            self.cards.each do |view_cast|
                res = JSON.parse(RestClient.get(view_cast.data_url).body)
                data = res['data']
                group_key = data[self.data_group_key]
                district_obj[group_key] = {} unless district_obj.has_key?(group_key)
                if Stream::CARD_KEYS.has_key?(view_cast.template_card.name.to_sym)
                    Stream::CARD_KEYS[view_cast.template_card.name.to_sym].each do |col_key|
                        district_obj[group_key][col_key] = "#{data[col_key]}" if data[col_key].present?
                    end
                end
            end
            district_obj.each do |key, value|
                value[self.data_group_key] = key
                cards_json << value
            end
            cards_json = cards_json.sort_by{|d| d[self.data_group_key]}
        else
            self.cards(false).each do |view_cast|
                d = {}
                d['view_cast_id'] = view_cast.datacast_identifier
                d['schema_id'] = view_cast.template_datum.s3_identifier
                if view_cast.template_card.name == 'toReportViolence'
                    begin
                        res = JSON.parse(RestClient.get(view_cast.data_url).body)
                        data = res['data']
                        d['date'] = Date.parse(data["when_and_where_it_occur"]['approximate_date_of_incident']).strftime('%F')
                        d['state'] = data["when_and_where_it_occur"]['state']
                        d["area_classification"] = data["when_and_where_it_occur"]["area_classification"]
                        d["lat"] = data["when_and_where_it_occur"]["lat"]
                        d["lng"] = data["when_and_where_it_occur"]["lng"]
                        d["title"] = data['the_people_involved']["title"]
                        d["does_the_state_criminalise_victims_actions"] = data["addendum"]["does_the_state_criminalise_victims_actions"]
                        d["party_whose_chief_minister_is_in_power"] =data["when_and_where_it_occur"]['party_whose_chief_minister_is_in_power']
                        d["was_incident_planned"] = data["the_incident"]["was_incident_planned"]
                        d["victim_social_classification"] = data["the_people_involved"]["victim_social_classification"]
                        d["accused_social_classification"] = data["the_people_involved"]["accused_social_classification"]
                        d["did_the_police_intervene"] = data["the_incident"]["did_the_police_intervene"]
                        d["did_the_police_intervention_prevent_death"] = data["the_incident"]["did_the_police_intervention_prevent_death"]
                        d["classification"] = data["the_incident"]["classification"]
                        d["police_vehicles_per_km"] = data["when_and_where_it_occur"]["police_vehicles_per_km"]
                        d["does_state_have_village_defence_force"] = data["when_and_where_it_occur"]["does_state_have_village_defence_force"]
                        d["police_to_population_in_state"] = data["when_and_where_it_occur"]["police_to_population_in_state"]
                        d["judge_to_population_in_state"] = data["when_and_where_it_occur"]["judge_to_population_in_state"]
                        d["is_hate_crime"] = data["hate_crime"]["is_hate_crime"]
                        d["is_gender_hate_crime"] = data["hate_crime"]["is_gender_hate_crime"]
                        d["is_caste_hate_crime"] = data["hate_crime"]["is_caste_hate_crime"]
                        d["is_race_hate_crime"] = data["hate_crime"]["is_race_hate_crime"]
                        d["is_religion_hate_crime"] = data["hate_crime"]["is_religion_hate_crime"]
                        d["is_political_affiliation_hate_crime"] = data["hate_crime"]["is_political_affiliation_hate_crime"]
                        d["is_sexual_orientation_and_gender_identity_hate_crime"] = data["hate_crime"]["is_sexual_orientation_and_gender_identity_hate_crime"]
                        d["is_disability_hate_crime"] = data["hate_crime"]["is_disability_hate_crime"]
                        d["is_ethnicity_hate_crime"] = data["hate_crime"]["is_ethnicity_hate_crime"]
                        d["which_law"] = data["addendum"]["which_law"]
                    rescue => e
                        view_cast.destroy
                        next
                    end
                elsif view_cast.template_card.name == "toReportJournalistKilling"
                    begin
                        res = JSON.parse(RestClient.get(view_cast.data_url).body)
                        data = res['data']
                        d['date'] = Date.parse(data["when_and_where_it_occur"]['date']).strftime('%F')
                        d["name"] = data["details_about_journalist"]["name"]
                        d["age"] = data["details_about_journalist"]["age"]
                        d["gender"] = data["details_about_journalist"]["gender"]
                        d["image_url"] = data["details_about_journalist"]["image_url"]
                        d["is_freelancer"] = data["details_about_journalist"]["is_freelancer"]
                        d["organisation"] = data["details_about_journalist"]["organisation"]
                        d["organisation_type"] = data["details_about_journalist"]["organisation_type"]
                        d["beat"] = data["details_about_journalist"]["beat"]
                        d["journalist_body_of_work"] = data["details_about_journalist"]["journalist_body_of_work"]
                        d["major_story_link_1"] = data["details_about_journalist"]["major_story_link_1"]
                        d["major_story_link_2"] = data["details_about_journalist"]["major_story_link_2"]
                        d["major_story_link_3"] = data["details_about_journalist"]["major_story_link_3"]
                        d["location"] = data["when_and_where_it_occur"]["location"]
                        d["state"] = data["when_and_where_it_occur"]["state"]
                        d["nature_of_assault"] = data["when_and_where_it_occur"]["nature_of_assault"]
                        d["accussed_names"] = data["when_and_where_it_occur"]["accussed_names"]
                        d["description_of_attack"] = data["when_and_where_it_occur"]["description_of_attack"]
                        d["motive_of_attack"] = data["when_and_where_it_occur"]["motive_of_attack"]
                        d["party"] = data["when_and_where_it_occur"]["party"]
                        d["is_case_registered"] = data["when_and_where_it_occur"]["is_case_registered"]
                        d["lat"] = data["when_and_where_it_occur"]["lat"]
                        d["lng"] = data["when_and_where_it_occur"]["lng"]
                    rescue => e
                        next
                    end
                elsif (view_cast.template_card.name == 'WaterExploitation' or self.include_data)
                    begin
                        res = JSON.parse(RestClient.get(view_cast.data_url).body)
                        data = res['data']
                        d.merge!(data)
                    rescue => e
                        view_cast.destroy
                        next
                    end
                end
                d['iframe_url']= "#{view_cast.template_card.index_html}?view_cast_id=#{view_cast.datacast_identifier}%26schema_id=#{view_cast.template_datum.s3_identifier}%26base_url=#{site.cdn_endpoint}"
                d['default_view'] = "#{view_cast.default_view}"
                cards_json << d
            end
        end
        #Sorting the data
        if self.include_data and self.order_by_key.present?
            if self.order_by_value == "desc"
                cards_json = cards_json.sort_by{|d| d[order_by_key].present? ? (order_by_type == 'date' ? Date.parse(d[order_by_key]) : d[order_by_key].to_s ) : '' }.reverse!
            else
                cards_json = cards_json.sort_by{|d| d[order_by_key].present? ? (order_by_type == 'date' ? Date.parse(d[order_by_key]) : d[order_by_key].to_s ) : '' }
            end
        end

        card_offset = self.offset || 0
        card_limit  = self.limit.present? ? (card_offset + (self.limit - 1)) : -1
        cards_json = cards_json[card_offset..card_limit]

        #Uploading the data
        encoded_file = Base64.encode64(cards_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, self.cdn_key, content_type, self.site.cdn_bucket)
        Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{self.datacast_identifier}/index.json"], 1)
        self.update_column(:last_published_at, Time.now)
    end

    def should_generate_new_friendly_id?
        title_changed?
    end

    def cdn_key
        "#{self.datacast_identifier}/index.json"
    end

    def cdn_rss_key
        "#{self.datacast_identifier}/index.xml"
    end

    def update_card_count
        self.card_count = self.cards.count
        self.update_column(:card_count, self.cards.count)
    end

    def publish_rss
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.rss(version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"){
                xml.channel {
                    xml.title "#{self.title}"
                    xml.description "#{self.description}"
                    xml.link "#{self.site.cdn_endpoint}"
                    xml.send("atom:link", "rel": "self","type": 'application/rss+xml',  "href": "#{self.site.cdn_endpoint}/#{self.cdn_rss_key}")
                    cards.each do |d|
                        if d.template_card.name == 'toStory'
                            xml.item {
                                begin
                                    data = JSON.parse(RestClient.get(d.data_url).body)["data"]
                                    xml.link data["url"]
                                    xml.title data['headline']
                                    xml.description data['summary']
                                    if data.has_key?("byline") and data["byline"]
                                        xml.author {
                                            xml.name data["byline"]
                                        }
                                    end
                                    if data['publishedat'].present?
                                        xml.pubDate Date.parse(data['publishedat']).strftime("%a, %e %b %Y %H:%M:%S %z")
                                    end
                                    if data.has_key?('imageurl') and data['imageurl'].present?
                                        xml.image {
                                            xml.url data['imageurl']
                                        }
                                    end
                                    if data.has_key?("genre") and data['genre'].present?
                                        xml.intersection data['genre']
                                    end
                                    if data.has_key?("subgenre") and data['subgenre'].present?
                                        xml.subintersection data['subgenre']
                                    end
                                rescue => e
                                    d.destroy
                                end
                            }
                        end
                    end
                }
            }
        end

        #Uploading the data
        encoded_file = Base64.encode64(builder.to_xml)
        content_type = "application/xml"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, self.cdn_rss_key, content_type, self.site.cdn_bucket)
        Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{self.cdn_rss_key}"], 1)
    end

    #PRIVATE
    private

    def before_create_set
        self.datacast_identifier = SecureRandom.hex(12) if self.datacast_identifier.blank?
    end

    def after_create_set
        StreamPublisher.perform_at(5.seconds.from_now, self.id)
    end

    def after_save_set
        #Creating folder entities from folder_list
        if self.folder_list.present?
            self.folder_list = self.folder_list.reject(&:empty?)
            prev_folder_ids = self.folder_ids.pluck(:entity_value)
            self.folder_list.each do |f|
                self.folder_ids.create({entity_type: "folder_id",entity_value: f})
            end
            self.folder_ids.where(entity_value: (prev_folder_ids - self.folder_list)).delete_all
        end

        #Creating ViewCast entities from view_cast_id
        if self.view_cast_id_list.present?
            self.view_cast_id_list = self.view_cast_id_list.first.split(",") # Because of the type of input we are getting
            self.view_cast_id_list = self.view_cast_id_list.reject(&:empty?)
            prev_view_cast_ids = self.view_cast_ids.pluck(:entity_value)
            self.view_cast_id_list.each do |f|
                self.view_cast_ids.create({entity_type: "view_cast_id",entity_value: f})
            end
            self.view_cast_ids.where(entity_value: (prev_view_cast_ids - self.view_cast_id_list)).delete_all
        end
        #Creating Excluded viewcast entities from view_cast_id
        if self.excluded_view_cast_id_list.present?
            self.excluded_view_cast_id_list = self.excluded_view_cast_id_list.first.split(",") # Because of the type of input we are getting
            self.excluded_view_cast_id_list = self.excluded_view_cast_id_list.reject(&:empty?)
            prev_excluded_view_cast_ids = self.excluded_view_cast_ids.pluck(:entity_value)
            self.excluded_view_cast_id_list.each do |f|
                self.excluded_view_cast_ids.create({entity_type: "view_cast_id",entity_value: f, is_excluded: true})
            end
            self.excluded_view_cast_ids.where(entity_value: (prev_excluded_view_cast_ids - self.excluded_view_cast_id_list)).delete_all
        end

        #Creating Card entities from card_list
        if self.card_list.present?
            self.card_list = self.card_list.reject(&:empty?)
            prev_card_ids = self.template_card_ids.pluck(:entity_value)
            self.card_list.each do |c|
                self.template_card_ids.create({entity_type: "template_card_id",entity_value: c})
            end
            self.template_card_ids.where(entity_value: (prev_card_ids - self.card_list)).delete_all
        end

        if self.collaborator_lists.present?
            self.collaborator_lists = self.collaborator_lists.reject(&:empty?)
            prev_collaborator_ids = self.permissions.pluck(:user_id)
            self.collaborator_lists.each do |c|
                user = User.find(c)
                a = user.create_permission("Stream", self.id, "contributor")
            end
            self.permissions.where(permissible_id: (prev_collaborator_ids - self.collaborator_lists.map{|a| a.to_i})).update_all(status: 'Deactivated')
        end

        self.pages.each do |p|
            PagePublisher.perform_async(p.id)
        end
    end

    def before_destroy_set
        begin
            Api::ProtoGraph::Utility.remove_from_cdn("#{self.cdn_key}", self.site.cdn_bucket)
            Api::ProtoGraph::CloudFront.invalidate(self.site, ["/#{self.cdn_key}"], 1)
        rescue => e
        end
    end

end
