class RegistrationsController < Devise::RegistrationsController

  def create
    super
    unless resource.id.nil?
      invites = PermissionInvite.where("email like ?", resource.email)
      if invites.first.present?
      	invites.each do |p|
      		Permission.create(user_id: resource.id, account_id: p.account_id, created_by: p.created_by, updated_by: p.updated_by, ref_role_slug: p.ref_role_slug)
      		p.destroy
      	end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation, :username)
  end

end