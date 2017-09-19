# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "----> Creating ICFJ Account"

icfj_account = Account.create({username: "ICFJ", domain: "icfj.org"})
pykih_account = Account.create({username: "pykih", domain: "pykih.com"})

puts "----> Creating Ref Roles"

RefRole.create(name: "Owner", slug: "owner",
                can_account_settings: true,
                can_template_design_do: true,
                can_template_design_publish: true, sort_order: 101)

RefRole.create(name: "Editor", slug: "editor",
                can_account_settings: true,
                can_template_design_do: false,
                can_template_design_publish: false, sort_order: 2)

RefRole.create(name: "Developer", slug: "developer",
                can_account_settings: false,
                can_template_design_do: true,
                can_template_design_publish: false, sort_order: 100)

RefRole.create(name: "Writer", slug: "writer",
                can_account_settings: false,
                can_template_design_do: false,
                can_template_design_publish: false, sort_order: 1)

puts "----> Creating users and permissions"
users = [["ritvvij.parrikh@pykih.com", "Ritvvij Parrikh" ,"ritvvijparrikh"], ["ab@pykih.com", "Amit Badheka", "amitbadheka"]]
users.each do |a|
  c = User.new(email: a[0], name: a[1], username: a[2], password: "indianmonsoon1234801" , confirmation_sent_at: Time.now)
  c.skip_confirmation!
  c.save
  Permission.create({ref_role_slug: "owner", account_id: icfj_account.id, user_id: c.id, created_by: c.id,updated_by: c.id})
end
user_id = User.first.id

folder = Folder.create({
  account_id: icfj_account.id,
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
puts "----> Creating Template Cards"

TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toExplain.git", name: "toExplain", git_branch: "master", git_repo_name: "ProtoGraph.Card.toExplain", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_explain.id, elevator_pitch: "Write explainers once. Reuse across stories.", description: "If news content focuses on the ‘Who, What, When, and Where,’ explainers looks to inform the reader of the ‘How and Why.’ It attempts to get behind the news to give the reader background information about a story to ensure that they are able to properly understand events as they unfold. <br/><br/>The toExplain card allows you to write short explainers that you can reuse across articles to provide readers with context.", s3_identifier: "f96a388525160ed7", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toSocial.git", name: "toSocial", git_branch: "master", git_repo_name: "ProtoGraph.Card.toSocial", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_share.id, elevator_pitch: "Create branded cover images for distribution.", description: "A huge portion of news distribution happens via social media when readers share your stories on their Facebook, Twitter and Instagram profiles. People encountering your reader’s post on their feed decide within a fraction of seconds whether to click on the article or no. Newsrooms focus a lot of time in writing creative headlines that will make people click.<br/><br/>Another thing that newsrooms could do is to leverage their brand's credibility. The Guardian knows that it’s brand is strong and people to know that this article is from The Guardian as early as possible. Hence, they add a horizontal banner on all social images. <br/><br/><img src='/img/guardian.png' style='width: 200px;'><br/><br/>The toSocial card helps you achieves just that. Upload your cover image and the toSocial card adds branding to it and resizes it into multiple sizes that are optimal for individual platforms. Once these images are created, you can either manually download these images and upload into your CMS’s meta tags or you can integrate with our API. With toSocial, whenever readers post your article on social media, that post acts an advertisement for your brand.", s3_identifier: "1ef5906398cf1149"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toQuiz.git", name: "toQuiz", git_branch: "master", git_repo_name: "ProtoGraph.Card.toQuiz", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_quiz.id, elevator_pitch: "Educate and engage readers on relevant issues with quiz.", description: "Just like the ones you know from school, only way more fun. This type of quiz has questions with definitive answers (right or wrong), and can include customized results.", s3_identifier: "7fda46f8c539"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toReportViolence.git", name: "toReportViolence", git_branch: "master", git_repo_name: "ProtoGraph.Card.toReportViolence", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_report_violence.id, elevator_pitch: "Structured Journalism: Document incidents of mob lynching.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "1cc352b8dae0", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toTimeline.git", name: "toTimeline", git_branch: "master", git_repo_name: "ProtoGraph.Card.toTimeline", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_timeline.id, elevator_pitch: "Build visually rich, mobile-first, interactive timelines.", description: "", s3_identifier: "abe2a24d7e5c4b81"})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toLink.git", name: "toLink", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLink", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_link.id, elevator_pitch: "", description: "", s3_identifier: "ce908c66e6861eb4"})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toReportJournalistKilling.git", name: "toReportJournalistKilling", git_branch: "master", git_repo_name: "ProtoGraph.Card.toReportJournalistKilling", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_report_journalist_killing.id, elevator_pitch: "", description: "", s3_identifier: "ce8d8ad1e0fa2fb1e99c", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toAudioPhoto.git", name: "toAudioPhoto", git_branch: "master", git_repo_name: "ProtoGraph.Card.toAudioPhoto", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_audio_photo.id, elevator_pitch: "", description: "", s3_identifier: "0834977043ff14a7"})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toDistrictProfile.git", name: "toDistrictProfile", git_branch: "master", git_repo_name: "ProtoGraph.Card.toDistrictProfile", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_district_profile.id, elevator_pitch: "", description: "", s3_identifier: "64c43aaad1d5c4848e2b", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toRainfall.git", name: "toRainfall", git_branch: "master", git_repo_name: "ProtoGraph.Card.toRainfall", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_rainfall.id, elevator_pitch: "", description: "", s3_identifier: "3c1017ae4c1bad611142", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toPoliticalLeadership.git", name: "toPoliticalLeadership", git_branch: "master", git_repo_name: "ProtoGraph.Card.toPoliticalLeadership", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_political_leadership.id, elevator_pitch: "", description: "", s3_identifier: "73c2e4114665d37c1532", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toLandUse.git", name: "toLandUse", git_branch: "master", git_repo_name: "ProtoGraph.Card.toLandUse", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_land_use.id, elevator_pitch: "", description: "", s3_identifier: "d884e08a38f267a689d1", has_multiple_uploads: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toWaterExploitation.git", name: "toWaterExploitation", git_branch: "master", git_repo_name: "ProtoGraph.Card.toWaterExploitation", status: "published", is_public: false, account_id: pykih_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_water_exploitation.id, elevator_pitch: "", description: "", s3_identifier: "ab7f37b31fb91496a7d7", has_multiple_uploads: true})
