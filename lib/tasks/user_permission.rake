namespace :user_permissions do
  desc 'Combines writer and developer roles into doer role.'
  task :reduce_roles  => :environment do
    # RefRole.where(slug: ['writer', 'developer']).destroy_all
    # if RefRole.where(slug: "doer").first.nil?
    #   RefRole.create(name: "Doer", slug: "doer",
    #               can_account_settings: false,
    #               can_template_design_do: true,
    #               can_template_design_publish: false, sort_order: 100)
    # end
    Permission.where(ref_role_slug: [['writer', 'developer']]).update_all(ref_role_slug: 'doer')
  end
end
