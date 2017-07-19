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
t_mobjustice = TemplateDatum.create({name: "toQuiz", version: "0.0.1", s3_identifier: "8fe46be1629b"})

puts "----> Creating Template Cards"

TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toExplain.git", name: "toExplain", git_branch: "master", git_repo_name: "ProtoGraph.Card.toExplain", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_explain.id, elevator_pitch: "Write explainers once. Reuse across stories.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "f96a388525160ed7"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toSocial.git", name: "toSocial", git_branch: "master", git_repo_name: "ProtoGraph.Card.toSocial", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_share.id, elevator_pitch: "Create branded cover images for distribution.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "1ef5906398cf1149"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toQuiz.git", name: "toQuiz", git_branch: "master", git_repo_name: "ProtoGraph.Card.toQuiz", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_quiz.id, elevator_pitch: "Create quizes.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "7fda46f8c539"})
TemplateCard.create({git_url: "git@github.com:icfjknightfellows/ProtoGraph.Card.toMobJustice.git", name: "toMobJustice", git_branch: "master", git_repo_name: "ProtoGraph.Card.toMobJustice", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_mobjustice.id, elevator_pitch: "Structured Journalism: Document incidents of mob lynching.", description: "askdna ldknas ldknas ldknas ldknas dlkans dlkasnd laksnd laksn dalskdn aslkdn aslkd naslkd nasldk nasld knasld kansdl kasndl kasnd lasknd laksnd alskdn alskdnaslkdnal dknasl dknasld knas dlknas dlkansd lkansd laksnd lasknd alksndl aksndals kdnalsk ndalkdn alsknd alsd", s3_identifier: "1cc352b8dae0"})
