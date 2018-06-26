namespace :rem_acc do
  desc "TODO"
  task update_table: :environment do
    Permission.where(permissible_type:"Account", ref_role_slug:"owner").find_each do |permission|
      if Account.exists?(id:permission.permissible_id)
        account=Account.find(permission.permissible_id)
        permission.update_columns(permissible_type: "Site", permissible_id: account.site.id)
      else
        puts "permission_id=#{permission.id}: account_id=#{permission.permissible_id} not found"
      end
    end

    PermissionInvite.where(permissible_type:"Account", ref_role_slug:"owner").find_each do |permission|
      if Account.exists?(id:permission.permissible_id)
        account=Account.find(permission.permissible_id)
        permission.update_columns(permissible_type: "Site", permissible_id: account.site.id)
      else
        puts "permission_id=#{permission.id}: account_id=#{permission.permissible_id} not found"
      end
    end

    Image.find_each do |image|
      account_id = image.account_id
      if Account.exists?(id: account_id)
        account=Account.find(account_id)
        image.update_columns(site_id: account.site.id)
      else
        puts "Account with id=#{account_id} not found"
      end
    end

    ImageVariation.find_each do |image_variation|
      if Image.exists?(id:image_variation.image_id)
        image=Image.find(image_variation.image_id)
        account_id = image.account_id
        if Account.exists?(id: account_id)
          account=Account.find(account_id)
          image_variation.update_columns(site_id: account.site.id)
        else
          puts "Account with id=#{account_id} not found"
        end
      end
    end

    TemplateCard.find_each do |template_card|
      account_id = template_card.account_id
        if Account.exists?(id: account_id)
          account=Account.find(account_id)
          template_card.update_columns(site_id: account.site.id)
        else
           puts "Account with id=#{account_id} not found"
        end
    end
  end
end
