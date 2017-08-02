# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "----> Creating ICFJ Account"

icfj_account = Account.create({username: "ICFJ", domain: "icfj.org"})

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


puts "----> Creating Template Datum"
user_id = User.first.id
t_explain = TemplateDatum.create({name: "toExplain", version: "0.0.1", s3_identifier: "2e804dc00b362f24"})
t_share = TemplateDatum.create({name: "toSocial", version: "0.0.1", s3_identifier: "9701121472ab331a"})
t_quiz = TemplateDatum.create({name: "toQuiz", version: "0.0.1", s3_identifier: "0eec77701464"})
t_report_violence = TemplateDatum.create({name: "toReportViolence", version: "0.0.1", s3_identifier: "8fe46be1629b"})

puts "----> Creating Template Cards"

TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toExplain.git", name: "toExplain", git_branch: "master", git_repo_name: "ProtoGraph.Card.toExplain", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_explain.id, elevator_pitch: "Write explainers once. Reuse across stories.", description: "If news content focuses on the ‘Who, What, When, and Where,’ explainers looks to inform the reader of the ‘How and Why.’ It attempts to get behind the news to give the reader background information about a story to ensure that they are able to properly understand events as they unfold. <br/><br/>The toExplain card allows you to write short explainers that you can reuse across articles to provide readers with context.", s3_identifier: "f96a388525160ed7"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toSocial.git", name: "toSocial", git_branch: "master", git_repo_name: "ProtoGraph.Card.toSocial", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_share.id, elevator_pitch: "Create branded cover images for distribution.", description: "A huge portion of news distribution happens via social media when readers share your stories on their Facebook, Twitter and Instagram profiles. People encountering your reader’s post on their feed decide within a fraction of seconds whether to click on the article or no. Newsrooms focus a lot of time in writing creative headlines that will make people click.<br/><br/>Another thing that newsrooms could do is to leverage their brand's credibility. The Guardian knows that it’s brand is strong and people to know that this article is from The Guardian as early as possible. Hence, they add a horizontal banner on all social images. <br/><br/><img src='/img/guardian.png' style='width: 200px;'><br/><br/>The toSocial card helps you achieves just that. Upload your cover image and the toSocial card adds branding to it and resizes it into multiple sizes that are optimal for individual platforms. Once these images are created, you can either manually download these images and upload into your CMS’s meta tags or you can integrate with our API. With toSocial, whenever readers post your article on social media, that post acts an advertisement for your brand.", s3_identifier: "1ef5906398cf1149"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toQuiz.git", name: "toQuiz", git_branch: "master", git_repo_name: "ProtoGraph.Card.toQuiz", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_quiz.id, elevator_pitch: "Educate and engage readers on relevant issues with quiz.", description: "Just like the ones you know from school, only way more fun. This type of quiz has questions with definitive answers (right or wrong), and can include customized results.", s3_identifier: "7fda46f8c539"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toReportViolence.git", name: "toReportViolence", git_branch: "master", git_repo_name: "ProtoGraph.Card.toReportViolence", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_report_violence.id, elevator_pitch: "Structured Journalism: Document incidents of mob lynching.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "1cc352b8dae0"})
