class User::RegistrationsController < Devise::RegistrationsController

  def edit
    @user_email = UserEmail.new
    @user_emails = current_user.user_emails
    super
  end

  def update
    @user_email = UserEmail.new
    @user_emails = current_user.user_emails
    super
  end

  def create
    super
    unless resource.id.nil?
      invites = PermissionInvite.where(email: resource.email)
      if invites.first.present?
      	invites.each do |p|
      		Permission.create(user_id: resource.id, permissible_type: p.permissible_type, permissible_id: p.permissible_id, created_by: p.created_by, updated_by: p.updated_by, ref_role_slug: p.ref_role_slug)
      		p.destroy
      	end
      end
      if resource.email.present?
        d = resource.email.split("@").last
        if d.present?
            sites = Site.where(email_domain: d, sign_up_mode: "Any email from your domain")
            sites.each do |a|
              per = Permission.create(user_id: resource.id, permissible_type: "Site", permissible_id: a.id, created_by: resource.id, updated_by: resource.id, ref_role_slug: a.default_role || 'writer')
            end
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation)
  end

end
