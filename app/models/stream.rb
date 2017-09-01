# == Schema Information
#
# Table name: streams
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  slug                :string(255)
#  description         :text(65535)
#  folder_id           :integer
#  account_id          :integer
#  datacast_identifier :string(255)
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  card_count          :integer
#  last_published_at   :datetime
#  order_by_key        :string(255)
#  order_by_value      :string(255)
#  limit               :integer
#  offset              :integer
#

class Stream < ApplicationRecord
    #CONSTANTS
    #GEMS
    include Associable
    include SearchCop
    extend FriendlyId
    friendly_id :title, use: :slugged

    search_scope :search do
        attributes :title, :description

        options :title, :type => :fulltext
        options :description, :type => :fulltext
    end


    #ASSOCIATIONS
    belongs_to :folder
    has_many :folder_ids, ->{folders}, class_name: "StreamEntity", foreign_key: "stream_id"
    has_many :template_card_ids, ->{template_cards}, class_name: "StreamEntity", foreign_key: "stream_id"

    #ACCESSORS
    attr_accessor :folder_list
    attr_accessor :card_list #Template Card list
    attr_accessor :tag_list
    #VALIDATIONS
    #CALLBACKS
    before_create :before_create_set
    after_save :after_save_set
    after_save :update_card_count

    #SCOPE
    #OTHER

    def cards
        query = {}
        query[:folder_id] = self.folder_ids.pluck(:entity_value) if self.folder_ids.count > 0
        query[:template_card_id] = self.template_card_ids.pluck(:entity_value) if self.template_card_ids.count > 0
        unless query.blank?
            view_cast = ViewCast.where(query).limit(self.limit).offset(self.offset)
        else
            view_cast = ViewCast.none
        end
        return view_cast
    end

    def publish_cards
        cards_json = []
        self.cards.each do |view_cast|
            res = JSON.parse(RestClient.get(view_cast.data_url).body)
            data = res['data']
            d = {}
            d['view_cast_id'] = view_cast.datacast_identifier
            d['schema_id'] = view_cast.template_datum.s3_identifier
            d['screen_shot_url'] = view_cast.render_screenshot_url
            if view_cast.template_card.name == 'toReportViolence'
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
            else
                # data.keys.each do |b|
                #     d[b] = data[b]
                # end
                # We do not require keys for all json files
            end
            d['iframe_url']= "#{view_cast.template_card.index_html(self.account)}?view_cast_id=#{view_cast.datacast_identifier}%26schema_id=#{view_cast.template_datum.s3_identifier}"
            cards_json << d
        end

        #Sorting the data
        if cards_json.first.has_key?('date')
            cards_json = cards_json.sort_by{|d| Date.parse(d['date'])}.reverse!
        end

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

    #PRIVATE
    private

    def before_create_set
        self.datacast_identifier = SecureRandom.hex(12)
    end

    def update_card_count
        self.card_count = self.cards.count
        self.update_column(:card_count, self.cards.count)
    end

    def after_save_set

        #Creating folder entities from folder_list
        if self.folder_list.present?
            self.folder_list = self.folder_list.reject(&:empty?)
            prev_folder_ids = self.folder_ids.pluck(:entity_value)
            self.folder_list.each do |f|
                self.folder_ids.create({entity_type: "folder_id",entity_value: f})
            end
            self.folder_ids.where(entity_type: "folder_id").where(entity_value: [prev_folder_ids - self.folder_list]).delete_all
        end
        #Creating Tag entities from tag_list
        # if self.tag_list.present?
        #     self.tag_list = self.tag_list.reject(&:empty?)

        #     prev_tag_ids = self.stream_entities.where(entity_type: "tag_id").pluck(:entity_value)
        #     self.tag_list.each do |t|
        #         self.stream_entities.create({entity_type: "tag_id",entity_value: t})
        #     end
        #     self.stream_entities.where(entity_type: "tag_id").where(entity_value: [prev_tag_ids - self.tag_list]).delete_all
        # end
        #Creating Card entities from card_list
        if self.card_list.present?
            self.card_list = self.card_list.reject(&:empty?)
            prev_card_ids = self.template_card_ids.pluck(:entity_value)
            self.card_list.each do |c|
                self.template_card_ids.create({entity_type: "template_card_id",entity_value: c})
            end
            self.template_card_ids.where(entity_type: "template_card_id").where(entity_value: [prev_card_ids - self.card_list]).delete_all
        end
    end

end
