# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "----> Creating ICFJ Account"

icfj_account = Account.create({username: "icfj", domain: "icfj.org"})

puts "----> Creating Ref Roles"

RefRole.create(name: "Owner", slug: "owner",
                can_account_settings: true,
                can_template_design_do: true,
                can_template_design_publish: true)

RefRole.create(name: "Editor", slug: "editor",
                can_account_settings: true,
                can_template_design_do: false,
                can_template_design_publish: false)

RefRole.create(name: "Developer", slug: "developer",
                can_account_settings: false,
                can_template_design_do: true,
                can_template_design_publish: false)

RefRole.create(name: "Writer", slug: "writer",
                can_account_settings: false,
                can_template_design_do: false,
                can_template_design_publish: false)

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
t_explain = TemplateDatum.create({git_url: "git@github.com:pykih/ProtoGraph.Schemas.git", git_branch: "master", name: "toExplain", account_id: icfj_account.id, created_by: user_id, updated_by: user_id})
t_brand = TemplateDatum.create({git_url: "git@github.com:pykih/ProtoGraph.Schemas.git", git_branch: "master", name: "toBrandAnIntersection", account_id: icfj_account.id, created_by: user_id, updated_by: user_id})
t_quiz = TemplateDatum.create({git_url: "git@github.com:pykih/ProtoGraph.Schemas.git", git_branch: "master", name: "toQuiz", account_id: icfj_account.id, created_by: user_id, updated_by: user_id})
t_share = TemplateDatum.create({git_url: "git@github.com:pykih/ProtoGraph.Schemas.git", git_branch: "master", name: "toShare", account_id: icfj_account.id, created_by: user_id, updated_by: user_id})


puts "----> Creating Template Cards"

TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toExplain.git", git_branch: "master", name: "toExplain", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_explain.id})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toBrandAnIntersection.git", git_branch: "master", name: "toBrandAnIntersection", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_brand.id, has_static_image: true})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toQuiz.git", git_branch: "master", name: "toQuiz", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_quiz.id})
TemplateCard.create({git_url: "git@github.com:pykih/ProtoGraph.Card.toShare.git", git_branch: "master", name: "toShare", status: "published", is_public: true, account_id: icfj_account.id, created_by: user_id, updated_by: user_id, template_datum_id: t_share.id})

