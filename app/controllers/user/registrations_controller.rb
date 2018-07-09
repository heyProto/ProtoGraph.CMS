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
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation)
  end

end
