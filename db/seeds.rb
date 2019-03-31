# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "----> Creating ICFJ SITE"

icfj_site = Site.create({name: "ICFJ", domain: "icfj.org"})
pykih_site = Site.create({name: "pykih", domain: "pykih.com"})

puts "----> Creating Ref Roles"

PermissionRole.create(name: "Owner", slug: "owner",
                      can_template_design_do: true,
                      can_template_design_publish: true, sort_order: 101)

PermissionRole.create(name: "Editor", slug: "editor",
                      can_template_design_do: false,
                      can_template_design_publish: false, sort_order: 2)

PermissionRole.create(name: "Doer", slug: "doer",
                      can_template_design_do: true,
                      can_template_design_publish: false, sort_order: 100)

puts "----> Creating users and permissions"
users = [["ritvvij.parrikh@pykih.com", "Ritvvij Parrikh" ,"ritvvijparrikh"], ["ab@pykih.com", "Amit Badheka", "amitbadheka"]]
users.each do |a|
  c = User.new(email: a[0], name: a[1], username: a[2], password: "indianmonsoon1234801" , confirmation_sent_at: Time.now)
  c.skip_confirmation!
  c.save
  Permission.create({ref_role_slug: "owner", site_id: icfj_site.id, user_id: c.id, created_by: c.id,updated_by: c.id})
end
user_id = User.first.id

folder = Folder.create({
                           site_id: icfj_site.id,
                           name: "Sample Project",
                           created_by: user_id,
                           updated_by: user_id
                       })

puts "----> Creating Template Datum"
t_explain = TemplateDatum.create({name: "toExplain", version: "0.0.1", s3_identifier: "2e804dc00b362f24"})
t_share = TemplateDatum.create({name: "toSocial", version: "0.0.1", s3_identifier: "9701121472ab331a"})
t_quiz = TemplateDatum.create({name: "toQuiz", version: "0.0.1", s3_identifier: "0eec77701464"})
t_report_violence = TemplateDatum.create({name: "toReportViolence", version: "0.0.1", s3_identifier: "8fe46be1629b"})
t_timeline = TemplateDatum.create({name: "toTimeline", version: "0.0.1", s3_identifier: "eadf798aca986e17"})
t_link = TemplateDatum.create({name: "toLink", version: "0.0.1", s3_identifier: "98f473c421f79d3f"})
t_report_journalist_killing = TemplateDatum.create({name: "toReportJournalistKilling", version: "0.0.1", s3_identifier: "48775d6fc8162c8bf958"})
t_audio_photo = TemplateDatum.create({name: "toAudioPhoto", version: "0.0.1", s3_identifier: "0aa5919b93028be5"})
t_district_profile = TemplateDatum.create({name: "toDistrictProfile", version: "0.0.1", s3_identifier: "c604e96223dd12fbf314"})
t_rainfall = TemplateDatum.create({name: "toRainfall", version: "0.0.1", s3_identifier: "1dec26e89d434e7bf055"})
t_political_leadership = TemplateDatum.create({name: "toPoliticalLeadership", version: "0.0.1", s3_identifier: "6ba6a13bf0ccd536d78c"})
t_land_use = TemplateDatum.create({name: "toLandUse", version: "0.0.1", s3_identifier: "cca2142e67a4aa8acdd8"})
t_water_exploitation = TemplateDatum.create({name: "toWaterExploitation", version: "0.0.1", s3_identifier: "1d5501e535539ee8020d"})
t_article = TemplateDatum.create({name: "toArticle", version: "0.0.1", s3_identifier: "2e86f6d67d84af232c65"})
t_move_to_a_new_city = TemplateDatum.create({name: "toMoveToANewCity", version: "0.0.1", s3_identifier: "50eae7c3be01f481b47"})
t_cluster = TemplateDatum.create({name: "toCluster", version: "0.0.1", s3_identifier: "4c23b3f55502fff884c5"})
t_story = TemplateDatum.create({name: "toStory", version: "0.0.1", s3_identifier: "ec6c33c26b5d6015bb40"})
t_water = TemplateDatum.create({name: "WaterExploitation", version: "0.0.1", s3_identifier: "599bd2e6d7c222338c15"})
t_company_profile = TemplateDatum.create({name: "toCompanyProfile", version: "0.0.1", s3_identifier: "14c17492ee0b0724"})
t_question = TemplateDatum.create({name: "toQuestion", version: "0.0.1", s3_identifier: "5543c8a38aa361c40fd8"})
t_media = TemplateDatum.create({name: "toMedia", version: "0.0.1", s3_identifier: "a755f29aa44bac02f904"})
t_survey_scores = TemplateDatum.create({name: "toSurveyScores", version: "0.0.1", s3_identifier: "2efee30aeed147ff9f9e"})
t_stink_cover = TemplateDatum.create({name: "toManualScavengerCoverVizCard", version: "0.0.1", s3_identifier: "66fa0ac4fcf3fa5b1401"})
t_compose_card = TemplateDatum.create({name: "ComposeCard", version: "0.0.1", s3_identifier: "e1b404edee927dfe58d6"})
t_image_card = TemplateDatum.create({name: "toImage", version: "0.0.1", s3_identifier: "65c8c3ec61ebcc5a3e68"})
t_video_youtube = TemplateDatum.create({name: "VideoYoutube", version: "0.0.1", s3_identifier: "2d19074cd276c06030c3"})
t_video_JWPlayer = TemplateDatum.create({name: "toVideoJWPlayer", version: "0.0.1", s3_identifier: "026ca82116c4730fd967"})
t_profile = TemplateDatum.create({name: "toProfile", version: "0.0.1", s3_identifier: "73100720900d849bea72"})
t_data_rating_with_drilldown = TemplateDatum.create({name: "toDataRatingWithDrillDown", version: "0.0.1", s3_identifier: "40c7877661e32f13d5ce"})
t_organ_viz = TemplateDatum.create({name: "toOrganVizCoverCard", version: "0.0.1", s3_identifier: "91374b9649fc94970645"})
t_education = TemplateDatum.create({name: "Education: District Map", version: "0.0.1", s3_identifier: "2c3c711bc90ef1dbff92"})
t_bio = TemplateDatum.create({name: "toBio", version: "0.0.1", s3_identifier: "5881371a8702951cd5b9"})

# Oxfam
t_data_irbf_grid = TemplateDatum.create({name: "toDataIRBFGrid", version: "0.0.1", s3_identifier: "1e0b58753372e47acf63"})
t_data_irbf_tooltip = TemplateDatum.create({name: "toDataIRBFTooltip", version: "0.0.1", s3_identifier: "a862be0d38c67658aed4"})

#DH
t_html = TemplateDatum.create({name: "toHTML", version: "0.0.1", s3_identifier: "95a46775489f3ce54267"})
t_datawrapper = TemplateDatum.create({name: "toDatawrapper", version: "0.0.1", s3_identifier: "1cad6e26582e31e45f99"})
#ceew
t_ceew_hero = TemplateDatum.create({name: "toCeewHero", version: "0.0.1", s3_identifier: "55edef336c691b9337ad"})
t_ceew_hero1 = TemplateDatum.create({name: "toCeewHeroFlow1", version: "0.0.1", s3_identifier: "ad2f8508e436e3d30639"})
t_ceew_hero2 = TemplateDatum.create({name: "toCeewHeroFlow2", version: "0.0.1", s3_identifier: "cee3693de88fca23fedf"})
t_ceew_parameter = TemplateDatum.create({name: "toCeewParameter", version: "0.0.1", s3_identifier: "89b85cf4efbd1e1368a3"})
t_ceew_policydrilldown = TemplateDatum.create({name: "toCeewPolicyDrillDown", version: "0.0.1", s3_identifier: "52e4b99aaeb0bfb80c3d"})
t_landing = TemplateDatum.create({name: "toCrossPub", version: "0.0.1", s3_identifier: "04c8efb64912bd8c58f2"})
t_credits = TemplateDatum.create({name: "ProtoGraph.Card.toCreditPartners", version: "0.0.1", s3_identifier: "acaadcfcba66f5948744"})
t_c4a = TemplateDatum.create({name: "ProtoGraph.Card.toCreditPartners", version: "0.0.1", s3_identifier: "ab2f46cc3cb242930f73"})
t_ispend = TemplateDatum.create({name: "ProtoGraph.Card.toIndiaSpendCard", version: "0.0.1", s3_identifier: "5dd680e900df7bb62102"})
t_image = TemplateDatum.create({name: "ProtoGraph.Card.toCoverImage", version: "0.0.1", s3_identifier: "7bac8ed35cf658f847f3"})
t_image_narrative = TemplateDatum.create({name: "ProtoGraph.Card.toImageNarrative", version: "0.0.1", s3_identifier: "0c9b38622e057d4ec06d"})
t_lcw = TemplateDatum.create({name: "ProtoGraph.Card.toRecordLandConflict", version: "0.0.1", s3_identifier: "8c7447bf389953a343d5"})
t_lcwhero = TemplateDatum.create({name: "ProtoGraph.Card.toLCWHero", version: "0.0.1", s3_identifier: "3ce2b0017023e74aa257"})

puts "----> Creating Template Cards"

TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toExplain.git", name: "toExplain", git_branch: "master", git_repo_name: "ProtoGraph.Card.toExplain", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_explain.id, elevator_pitch: "Write explainers once. Reuse across stories.", description: "If news content focuses on the ‘Who, What, When, and Where,’ explainers looks to inform the reader of the ‘How and Why.’ It attempts to get behind the news to give the reader background information about a story to ensure that they are able to properly understand events as they unfold. <br/><br/>The toExplain card allows you to write short explainers that you can reuse across articles to provide readers with context.", s3_identifier: "f96a388525160ed7", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toSocial.git", name: "toSocial", git_branch: "master", git_repo_name: "ProtoGraph.Card.toSocial", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_share.id, elevator_pitch: "Create branded cover images for distribution.", description: "A huge portion of news distribution happens via social media when readers share your stories on their Facebook, Twitter and Instagram profiles. People encountering your reader’s post on their feed decide within a fraction of seconds whether to click on the article or no. Newsrooms focus a lot of time in writing creative headlines that will make people click.<br/><br/>Another thing that newsrooms could do is to leverage their brand's credibility. The Guardian knows that it’s brand is strong and people to know that this article is from The Guardian as early as possible. Hence, they add a horizontal banner on all social images. <br/><br/><img src='/img/guardian.png' style='width: 200px;'><br/><br/>The toSocial card helps you achieves just that. Upload your cover image and the toSocial card adds branding to it and resizes it into multiple sizes that are optimal for individual platforms. Once these images are created, you can either manually download these images and upload into your CMS’s meta tags or you can integrate with our API. With toSocial, whenever readers post your article on social media, that post acts an advertisement for your brand.", s3_identifier: "1ef5906398cf1149", allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toQuiz.git", name: "toQuiz", git_branch: "master", git_repo_name: "ProtoGraph.Card.toQuiz", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_quiz.id, elevator_pitch: "Educate and engage readers on relevant issues with quiz.", description: "Just like the ones you know from school, only way more fun. This type of quiz has questions with definitive answers (right or wrong), and can include customized results.", s3_identifier: "7fda46f8c539", allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toReportViolence.git", name: "toReportViolence", git_branch: "master", git_repo_name: "ProtoGraph.Card.toReportViolence", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_report_violence.id, elevator_pitch: "Structured Journalism: Document incidents of mob lynching.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "1cc352b8dae0", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toTimeline.git", name: "toTimeline", git_branch: "master", git_repo_name: "ProtoGraph.Card.toTimeline", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_timeline.id, elevator_pitch: "Build visually rich, mobile-first, interactive timelines.", description: "", s3_identifier: "abe2a24d7e5c4b81", allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toLink.git", name: "toLink", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLink", status: "published", is_public: true, site_id: icfj_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_link.id, elevator_pitch: "", description: "", s3_identifier: "ce908c66e6861eb4", allowed_views: ["laptop", "mobile", "list"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toReportJournalistKilling.git", name: "toReportJournalistKilling", git_branch: "master", git_repo_name: "ProtoGraph.Card.toReportJournalistKilling", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_report_journalist_killing.id, elevator_pitch: "", description: "", s3_identifier: "ce8d8ad1e0fa2fb1e99c", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toAudioPhoto.git", name: "toAudioPhoto", git_branch: "master", git_repo_name: "ProtoGraph.Card.toAudioPhoto", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_audio_photo.id, elevator_pitch: "", description: "", s3_identifier: "0834977043ff14a7", allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toDistrictProfile.git", name: "toDistrictProfile", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDistrictProfile", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_district_profile.id, elevator_pitch: "", description: "", s3_identifier: "64c43aaad1d5c4848e2b", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toRainfall.git", name: "toRainfall", git_branch: "master", git_repo_name: "ProtoGraph.Card.toRainfall", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_rainfall.id, elevator_pitch: "", description: "", s3_identifier: "3c1017ae4c1bad611142", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toPoliticalLeadership.git", name: "toPoliticalLeadership", git_branch: "master", git_repo_name: "ProtoGraph.Card.toPoliticalLeadership", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_political_leadership.id, elevator_pitch: "", description: "", s3_identifier: "73c2e4114665d37c1532", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toLandUse.git", name: "toLandUse", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLandUse", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_land_use.id, elevator_pitch: "", description: "", s3_identifier: "d884e08a38f267a689d1", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toWaterExploitation.git", name: "toWaterExploitation", git_branch: "master", git_repo_name: "ProtoGraph.Card.toWaterExploitation", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_water_exploitation.id, elevator_pitch: "", description: "", s3_identifier: "ab7f37b31fb91496a7d7", has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toArticle.git", name: "toArticle", git_branch: "master", git_repo_name: "ProtoGraph.Card.toArticle", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_article.id, elevator_pitch: "", description: "", s3_identifier: "171fda4fca046ddf4490", allowed_views: ["big_image_text", "feature_image", "thumbnail", "title_text", "small_image_text"]})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toMoveToANewCity.git", name: "toMoveToANewCity", git_branch: "master", git_repo_name: "ProtoGraph.Card.toMoveToANewCity", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_move_to_a_new_city.id, elevator_pitch: "", description: "", s3_identifier: "21931558341c201c8a44",has_multiple_uploads: true, allowed_views: ["laptop", "mobile"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tocluster.git", name: "toCluster", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCluster", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_cluster.id, elevator_pitch: "", description: "", s3_identifier: "58b1b2874072b834cdd5",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tostory.git", name: "toStory", git_branch: "master", git_repo_name: "ProtoGraph.Card.toStory", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_story.id, elevator_pitch: "", description: "", s3_identifier: "3a22007055b900325586",has_multiple_uploads: false, allowed_views: ["col16","col7", "col4", "col3", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.towaterexploitationv2.git", name: "WaterExploitation", git_branch: "master", git_repo_name: "ProtoGraph.Card.WaterExploitation", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_water.id, elevator_pitch: "", description: "", s3_identifier: "c2dd73c6a699f10a3f3e",has_multiple_uploads: true, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tocompanyprofile.git", name: "toCompanyProfile", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCompanyProfile", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_company_profile.id, elevator_pitch: "", description: "", s3_identifier: "49e1db2feaeab4734f51",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toquestion.git", name: "toQuestion", git_branch: "master", git_repo_name: "ProtoGraph.Card.toQuestion", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_question.id, elevator_pitch: "", description: "", s3_identifier: "22c19a0c9a5f5c05bf66",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tomedia.git", name: "toMedia", git_branch: "master", git_repo_name: "ProtoGraph.Card.toMedia", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_media.id, elevator_pitch: "", description: "", s3_identifier: "346cad2b4c1598679cfe",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toSurveyScores.git", name: "toSurveyScores", git_branch: "master", git_repo_name: "ProtoGraph.Card.toSurveyScores", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_survey_scores.id, elevator_pitch: "", description: "", s3_identifier: "25d44080867a4cd6b430",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tomanualscavengercovervizcard.git", name: "toManualScavengerCoverVizCard", git_branch: "master", git_repo_name: "ProtoGraph.Card.toManualScavengerCoverVizCard", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_stink_cover.id, elevator_pitch: "", description: "", s3_identifier: "3dcab1e230b429d5a921",has_multiple_uploads: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.composecard.git", name: "toParagraph", git_branch: "master", git_repo_name: "ProtoGraph.Card.ComposeCard", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_compose_card.id, elevator_pitch: "", description: "", s3_identifier: "8c7f4a1291ed39c16d26",has_multiple_uploads: false, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toimage.git", name: "toImage", git_branch: "master", git_repo_name: "ProtoGraph.Card.toImage", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_image_card.id, elevator_pitch: "", description: "", s3_identifier: "5c33be70482e129de6f0",has_multiple_uploads: false, allowed_views: ["col16", "col7", "col4", "col3", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.videoyoutube.git", name: "VideoYoutube", git_branch: "master", git_repo_name: "ProtoGraph.Card.VideoYoutube", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_video_youtube.id, elevator_pitch: "", description: "", s3_identifier: "c9e5bf64ab18cb01e491",has_multiple_uploads: false, allowed_views: ["col16", "col7", "col4", "col3", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tovideojwplayer.git", name: "toVideo: JWPlayer", git_branch: "master", git_repo_name: "ProtoGraph.Card.toVideoJWPlayer", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_video_JWPlayer.id, elevator_pitch: "", description: "", s3_identifier: "f4ab7fb4e0646ca69d5e",has_multiple_uploads: false, allowed_views: ["col16", "col7", "col4", "col3", "col2"], sort_order: 35})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toprofile.git", name: "toProfile", git_branch: "master", git_repo_name: "ProtoGraph.Card.toProfile", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_profile.id, elevator_pitch: "", description: "", s3_identifier: "4248b573a96cbadfb321",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.todataratingwithdrilldown.git", name: "toData: Rating with drill down", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDataRatingWithDrillDown", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_data_rating_with_drilldown.id, elevator_pitch: "", description: "", s3_identifier: "8839daf4eeffd56d81b2",has_multiple_uploads: false, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.todatairbfgrid.git", name: "toData: IRBF Grid", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDataIRBFGrid", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_data_irbf_grid.id, elevator_pitch: "", description: "", s3_identifier: "66827b60da0c3211d776",has_multiple_uploads: false, allowed_views: ["grid"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.todatairbftooltip.git", name: "toData: IRBF Tooltip", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDataIRBFTooltip", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_data_irbf_tooltip.id, elevator_pitch: "", description: "", s3_identifier: "2931317d3b08401c2dd9",has_multiple_uploads: false, allowed_views: ["tooltip"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toorganvizcover.git", name: "Organ: CoverViz", git_branch: "master", git_repo_name: "ProtoGraph.Card.toOrganCoverVizCard", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_organ_viz.id, elevator_pitch: "", description: "", s3_identifier: "9e058a64d0949988645e",has_multiple_uploads: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toeducationdistrictmap.git", name: "Education: District Map", git_branch: "master", git_repo_name: "ProtoGraph.Card.toEducationDistrictMap", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_education.id, elevator_pitch: "", description: "", s3_identifier: "85e16c8b12fda33055f6",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tohtml.git", name: "DH: HTML", git_branch: "master", git_repo_name: "ProtoGraph.Card.HTMLCard", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_html.id, elevator_pitch: "", description: "", s3_identifier: "8346e50f6a0c4858703e",has_multiple_uploads: false, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/todwchart.git", name: "DH: Datawrapper", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDWChart", status: "published", is_public: false, site_id: dh_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_datawrapper.id, elevator_pitch: "", description: "", s3_identifier: "79fadf27771f80149d7b",has_multiple_uploads: false, allowed_views: ["col16", "col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tobio.git", name: "toBio", git_branch: "master", git_repo_name: "ProtoGraph.Card.toBio", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_bio.id, elevator_pitch: "", description: "", s3_identifier: "c80b9f40b64d145de511",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3", "col2"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toceewhero.git", name: "Ceew: Hero", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCEEWHero", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ceew_hero.id, elevator_pitch: "", description: "", s3_identifier: "8ce281e5039dce51e067",has_multiple_uploads: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toceewheroflow1.git", name: "Ceew: HeroFlow1", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCEEWHeroFlow1", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ceew_hero1.id, elevator_pitch: "", description: "", s3_identifier: "ff0474e2588c0a6d3e08",has_multiple_uploads: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toceewheroflow2.git", name: "Ceew: HeroFlow2", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCEEWHeroFlow2", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ceew_hero2.id, elevator_pitch: "", description: "", s3_identifier: "6a1be87e840877cd7119",has_multiple_uploads: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toceewparameter.git", name: "Ceew: Parameter", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCEEWParameter", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ceew_parameter.id, elevator_pitch: "", description: "", s3_identifier: "04870ca59109bb3dfdea",has_multiple_uploads: false, allowed_views: ["col7", "col4", "col3"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toceewpolicydrilldown.git", name: "Ceew: PolicyDrillDown", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCEEWPolicyDrillDown", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ceew_policydrilldown.id, elevator_pitch: "", description: "", s3_identifier: "470b7c34f8f68c1b429c",has_multiple_uploads: false, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tolanding.git", name: "toCrossPub", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLanding", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_landing.id, elevator_pitch: "", description: "", s3_identifier: "6f4657adaa3c900aa1a0",has_multiple_uploads: false, is_editable: false, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tocredits.git", name: "toCreditPartners", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCreditPartners", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_credits.id, elevator_pitch: "", description: "", s3_identifier: "d583b2ea191031c6f0fc",has_multiple_uploads: false, is_editable: true, allowed_views: ["col16", "col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.proc4ahealthtools.git", name: "C4A Healthtools", git_branch: "master", git_repo_name: "ProtoGraph.Card.proC4Ahealthtools", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_c4a.id, elevator_pitch: "", description: "", s3_identifier: "b011d28f52396081faa8",has_multiple_uploads: false, is_editable: true, allowed_views: ["col16", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toindiaspendhatecrime.git", name: "toIndiaSpendCard", git_branch: "master", git_repo_name: "ProtoGraph.Card.toIndiaSpendCard", status: "published", is_public: false, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_ispend.id, elevator_pitch: "", description: "", s3_identifier: "79c10f895565f79dca4b",has_multiple_uploads: true, is_editable: true, allowed_views: ["col7", "col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.toimagenarrative.git", name: "toImageNarrative", git_branch: "master", git_repo_name: "ProtoGraph.Card.toImageNarrative", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_image.id, elevator_pitch: "", description: "", s3_identifier: "9273eab737631412dd01",has_multiple_uploads: true, is_editable: true, allowed_views: ["col7","col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tocoverimage.git", name: "toCoverImage", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCoverImage", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_image.id, elevator_pitch: "", description: "", s3_identifier: "99e448b6fcb668c5a3d4",has_multiple_uploads: true, is_editable: true, allowed_views: ["col16", "col7","col4", 'col3', 'col2']})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.torecordlandconflict.git", name: "toRecordLandConflict", git_branch: "master", git_repo_name: "ProtoGraph.Card.toRecordLandConflict", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_lcw.id, elevator_pitch: "", description: "", s3_identifier: "089131ca8ef9a3dcaad8",has_multiple_uploads: false, is_editable: true, allowed_views: ["col7","col4"]})
TemplateCard.create({git_url: "git@bitbucket.org:pykih_/protograph.card.tocoverimage.git", name: "toLCWHero", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLCWHero", status: "published", is_public: true, site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_lcwhero.id, elevator_pitch: "", description: "", s3_identifier: "55825b09931bee16055a",has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"]})


TemplatePage.create({
                        name: "Homepage: Vertical",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "014521f868f5c2e01cf7",
                        created_by: user_id,
                        updated_by: user_id
                    })

TemplatePage.create({
                        name: "article",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "0f0626a32cd514568f6f",
                        created_by: user_id,
                        updated_by: user_id
                    })

TemplatePage.create({
                        name: "map",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "41108c78d5b87f84dc73",
                        created_by: user_id,
                        updated_by: user_id
                    })


TemplatePage.create({
                        name: "data grid",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "0679c03c61fff6ab1a52",
                        created_by: user_id,
                        updated_by: user_id
                    })

TemplatePage.create({
                        name: "irbi 2017: data grid",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "2790fa05bd740dc82638",
                        created_by: user_id,
                        updated_by: user_id
                    })

TemplatePage.create({
                        name: "Ceew: data grid",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "4be452da8a449ca1da29",
                        created_by: 2,
                        updated_by: 2
                    })

TemplatePage.create({
                        name: "IndiaSpend: data grid",
                        git_url: "",
                        git_branch: "master",
                        git_repo_name: "",
                        status: "published",
                        is_public: true,
                        description: "",
                        s3_identifier: "2236cd589b5eba74af89",
                        created_by: 2,
                        updated_by: 2
                    })


#========= New Version ==========#

tpage_dte_grid = TemplateApp.create({
    site_id: pykih_site.id,
    name: "DTE: data grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/cse-dte.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplatePage.create({
    site_id: pykih_site.id,
    name: "DTE: data grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "ea63a56d0734b717fc8d",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_dte_grid.id
})

tpage_proto_team = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Proto: team grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/proto-public-team.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "Proto: team grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "d6b2b19c6788c6465011",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_proto_team.id
})

tpage_proto_partner = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Proto: partner grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/proto-public-partner.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "Proto: partner grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "37cda85b8a50637fd5d7",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_proto_partner.id
})

tpage_proto_format = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Proto: format grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/proto-public-format.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "Proto: format grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "7613998bc8dd2fc20f94",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_proto_format.id
})

tpage_metoo_grid = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Metoo: data grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/metoo.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "Metoo: data grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "77fd88bf8fff7450b485",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_metoo_grid.id
})


tpage_hatecrimehindi_grid = TemplateApp.create({
    site_id: pykih_site.id,
    name: "HateCrime Hindi: data grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/hatecrime-hindi.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "HateCrime Hindi: data grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "5d7e4639af0405cd45ba",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_hatecrimehindi_grid.id
})

# PROTO Home page
tpage_proto_public = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Proto: Public Landing",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/public-website.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplatePage.create({
    site_id: pykih_site.id,
    name: "DTE: data grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "28cea69cc6e27466d535",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_proto_public.id
})

tpage_oxfam_grid = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Oxfam: data grid",
    genre: "page",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/oxfam-grid.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplatePage.create({
    site_id: pykih_site.id,
    name: "Oxfam: data grid",
    git_repo_name: "",
    status: "published",
    is_public: true,
    s3_identifier: "dfd8a041d1daa9be3f0a",
    created_by: user_id,
    updated_by: user_id,
    template_app_id: tpage_oxfam_grid.id
})


# -----------------------------------------------------------------------------------------------
# CARDS
# -----------------------------------------------------------------------------------------------


tapp_footer = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Footer",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


t_footer = TemplateDatum.create({name: "ProtoGraph.Card.toFooter", version: "0.0.1", s3_identifier: "0082ce83c98144f9990c", template_app_id: tapp_footer.id, site_id: pykih_site.id})


tapp_footer_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Footer",
    genre: "card",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/footer.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "Footer", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLCWHero", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_footer.id, s3_identifier: "fa446ad88c6fd390e79b", has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_footer_card.id})



tapp_coverstory = TemplateApp.create({
    site_id: pykih_site.id,
    name: "toCoverStory",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})



t_cstory = TemplateDatum.create({name: "ProtoGraph.Card.toCoverStory", version: "0.0.1", s3_identifier: "79fa50d0df6bc3b7adb1", template_app_id: tapp_coverstory.id, site_id: pykih_site.id})

tapp_coverstory_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "toCoverStory",
    genre: "card",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/tocoverstory.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


TemplateCard.create({name: "toCoverStory", git_branch: "master", git_repo_name: "ProtoGraph.Card.toCoverStory", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_cstory.id, s3_identifier: "fe91c98819d83e422f2c ",has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_coverstory_card.id})

# FactChecker Header Card
tapp_factchecker_header = TemplateApp.create({
    site_id: pykih_site.id,
    name: "FactCheckerHeader",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

t_factchecker_header = TemplateDatum.create({name: "ProtoGraph.Card.FactCheckerHeader", version: "0.0.1", s3_identifier: "0de591f58cc968cb063e", template_app_id: tapp_factchecker_header.id, site_id: pykih_site.id})

tapp_factchecker_header_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "FactCheckerHeader",
    genre: "card",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/factcheckerheader.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "FactCheckerHeader", git_branch: "master", git_repo_name: "ProtoGraph.Card.FactCheckerHeader", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_factchecker_header.id, s3_identifier: "786b8a918de9dc171ca6", has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_factchecker_header_card.id})

# Header Card
tapp_header = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Header",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

t_header = TemplateDatum.create({name: "ProtoGraph.Card.toHeader", version: "0.0.1", s3_identifier: "42f4dc7c665cc0b6d803", template_app_id: tapp_header.id, site_id: pykih_site.id})

tapp_header_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "Header",
    genre: "card",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.cards.toheader.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "Header", git_branch: "master", git_repo_name: "ProtoGraph.Card.toHeader", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_header.id, s3_identifier: "911359e9dad3e71f4274", has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_header_card.id})

# DTE Modal Card
tapp_dte_modal = TemplateApp.create({
    site_id: pykih_site.id,
    name: "DteCourtCase",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

t_dte_modal = TemplateDatum.create({name: "ProtoGraph.Card.toDteCourtCase", version: "0.0.1", s3_identifier: "25c75ebc0843b743b646", template_app_id: tapp_dte_modal.id, site_id: pykih_site.id})

tapp_dte_modal_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "DteCourtCase",
    genre: "card",
    pitch: "",
    description: "",
    is_public: true,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.cards.todtecourtcase.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "DteCourtCase", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDteCourtCase", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_dte_modal.id, s3_identifier: "572ec58c71b757b1cae8", has_multiple_uploads: false, is_editable: true, allowed_views: ["col7","col4"], template_app_id: tapp_dte_modal_card.id})

# MeToo Card
tapp_metoo = TemplateApp.create({
    site_id: pykih_site.id,
    name: "ToRecordMeToo",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: false,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


t_metoo = TemplateDatum.create({name: "ProtoGraph.Card.torecordmetoo", version: "0.0.1", s3_identifier: "2de38f040e0c87eb9d0d", template_app_id: tapp_metoo.id, site_id: pykih_site.id})


tapp_metoo_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "ToRecordMeToo",
    genre: "card",
    pitch: "",
    description: "",
    is_public: false,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/torecordmetoo.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "ToRecordMeToo", git_branch: "master", git_repo_name: "ProtoGraph.Card.toRecordMeToo", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_metoo.id, s3_identifier: "93470692abafeef5473d", has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_metoo_card.id})


# Oxfam CTA Card
tapp_oxfam_cta = TemplateApp.create({
    site_id: pykih_site.id,
    name: "ToOxfamCTA",
    genre: "datum",
    pitch: "",
    description: "",
    is_public: false,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.schemas.git",
    is_system_installed: true,
    is_backward_compatible: true,
})


t_oxfam_cta = TemplateDatum.create({name: "ProtoGraph.Card.ToOxfamCTA", version: "0.0.1", s3_identifier: "2f59e63fc5d2a6e719c2", template_app_id: tapp_oxfam_cta.id, site_id: pykih_site.id})


tapp_oxfam_cta_card = TemplateApp.create({
    site_id: pykih_site.id,
    name: "ToOxfamCTA",
    genre: "card",
    pitch: "",
    description: "",
    is_public: false,
    change_log: "",
    git_url: "git@bitbucket.org:heyProto/protograph.card.responsiblebiz-cta.git",
    is_system_installed: true,
    is_backward_compatible: true,
})

TemplateCard.create({name: "ToOxfamCTA", git_branch: "master", git_repo_name: "ProtoGraph.Card.ToOxfamCTA", status: "published", site_id: pykih_site.id, created_by: user_id, updated_by: user_id, template_datum_id: t_oxfam_cta.id, s3_identifier: "7f012abd6ba431f90d1e", has_multiple_uploads: false, is_editable: true, allowed_views: ["col16","col4"], template_app_id: tapp_oxfam_cta_card.id})

