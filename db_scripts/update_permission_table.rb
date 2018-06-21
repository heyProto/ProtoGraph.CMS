Permission.where(permissible_type:"Account", ref_role_slug:"owner").find_each do |permission|
    if Account.exists?(id:permission.permissible_id)
        account=Account.find(permission.permissible_id)
        permission.update_columns(permissible_type: "Site", permissible_id: account.site.id)
    else
        puts "permission_id=#{permission.id}: account_id=#{permission.permissible_id} not found"
    end
end
