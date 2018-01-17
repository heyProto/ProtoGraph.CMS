# == Schema Information
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
    include Associable
    extend FriendlyId
    friendly_id :title, use: :slugged


    #ASSOCIATIONS
    belongs_to :folder, optional: true
    has_many :folder_ids, ->{folders}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :template_card_ids, ->{template_cards}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :view_cast_ids, ->{view_casts}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :excluded_view_cast_ids, ->{excluded_view_casts}, class_name: "StreamEntity", foreign_key: "stream_id"

    #ACCESSORS
    attr_accessor :folder_list
    attr_accessor :card_list #Template Card list
    attr_accessor :view_cast_id_list
    attr_accessor :excluded_view_cast_id_list
    #VALIDATIONS
    validates :data_group_key, presence: true, if: :is_grouped_data_stream
    #CALLBACKS
    before_create :before_create_set
    after_create :after_create_set
    after_save :after_save_set
    after_save :update_card_count

    #SCOPE
    #OTHER

    def cards(apply_limit=true)
        if is_automated_stream
            if col_name == "Site"
                site = Site.find(col_id)
                view_casts = site.view_casts.limit(self.limit).offset(self.offset)
            else col_name == "RefCategory"
                ref_cat = RefCategory.find(col_id)
                view_casts = ref_cat.view_casts.limit(self.limit).offset(self.offset)
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
            view_cast_or = self.view_cast_ids.present? ? account.view_casts.where(id: self.view_cast_ids.pluck(:entity_value)).where.not(folder_id: account.folders.where(is_trash: true).first.id) : ViewCast.none
            view_casts = view_cast + view_cast_or
            return view_casts
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
                if view_cast.template_card.name == 'toDistrictProfile'
                    district_obj[group_key]["screen_shot_url"] = view_cast.render_screenshot_url
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
                d['screen_shot_url'] = view_cast.render_screenshot_url
                if view_cast.template_card.name == 'toReportViolence'
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
                elsif view_cast.template_card.name == "toReportJournalistKilling"
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
                elsif (view_cast.template_card.name == 'WaterExploitation' or self.include_data)
                    res = JSON.parse(RestClient.get(view_cast.data_url).body)
                    data = res['data']
                    d.merge!(data)
                end
                d['iframe_url']= "#{view_cast.template_card.index_html(self.account)}?view_cast_id=#{view_cast.datacast_identifier}%26schema_id=#{view_cast.template_datum.s3_identifier}"
                d['default_view'] = "#{view_cast.default_view}"
                cards_json << d
            end
        end
        #Sorting the data
        if self.include_data and self.order_by_key.present?
            if self.order_by_value == "desc"
                cards_json = cards_json.sort_by{|d| d[order_by_key].present? ? (order_by_type == 'date' ? Date.parse(d[order_by_key]) : d[order_by_key] ) : nil }.reverse!
            else
                cards_json = cards_json.sort_by{|d| d[order_by_key].present? ? (order_by_type == 'date' ? Date.parse(d[order_by_key]) : d[order_by_key] ) : nil }
            end
        end

        card_offset = self.offset || 0
        card_limit  = self.limit.present? ? (card_offset + (self.limit - 1)) : -1
        cards_json = cards_json[card_offset..card_limit]

        #Uploading the data
        encoded_file = Base64.encode64(cards_json.to_json)
        content_type = "application/json"
        resp = Api::ProtoGraph::Utility.upload_to_cdn(encoded_file, self.cdn_key, content_type)
        if self.account.cdn_id != ENV['AWS_CDN_ID']
            Api::ProtoGraph::CloudFront.invalidate(self.account, ["/#{self.datacast_identifier}/index.json"], 1)
        end
        Api::ProtoGraph::CloudFront.invalidate(nil, ["/#{self.datacast_identifier}/index.json"], 1)

        self.update_column(:last_published_at, Time.now)
    end

    def should_generate_new_friendly_id?
        title_changed?
    end

    def cdn_key
        "#{self.datacast_identifier}/index.json"
    end

    def update_card_count
        self.card_count = self.cards.count
        self.update_column(:card_count, self.cards.count)
    end

    #PRIVATE
    private

    def before_create_set
        self.datacast_identifier = SecureRandom.hex(12) if self.datacast_identifier.blank?
    end

    def after_create_set
        Thread.new do
            sleep 1
            self.publish_cards
            ActiveRecord::Base.connection.close
        end
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
    end

end
