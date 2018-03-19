class PermissionInvitesController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_add_site_people
  before_action :set_permission_invite, only: [:show, :edit, :update, :destroy]

  def index
    @permissions = @site.permissions.not_hidden.includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @site.permission_invites
    @people_count = @site.permissions.not_hidden.count
    @pending_invites_count = @site.permission_invites.count
    @permission_invites = @site.permission_invites
    @permission_roles = PermissionRole.where.not(slug: "owner").pluck(:name, :slug)
    @is_admin = true
  end

  def create
    @permission_invite = PermissionInvite.new(permission_invite_params)
    per = UserEmail.find_by(email: @permission_invite.email)
    user = per.present? ? per.user : nil
    if user.present?
      a = user.create_permission(permission_invite_params[:permissible_type], permission_invite_params[:permissible_id], @permission_invite.ref_role_slug)
      if a.id.present?
        redirect_to permission_invite_params[:redirect_url], notice: t("permission_invite.add")
      else
        a.errors.each do |key, value|
          @permission_invite.errors.add(:email, value)
        end
        @permissions = @site.permissions.not_hidden.includes(:user).page params[:page]
        @permission_invites = @site.permission_invites
        @people_count = @site.permissions.not_hidden.count
        @pending_invites_count = @site.permission_invites.count
        @permission_invites = @site.permission_invites
        @permission_roles = PermissionRole.where.not(slug: "owner").pluck(:name, :slug)
        @show_modal = true
        render "permission_invites/index"
      end
    else
      if @permission_invite.save
        PermissionInvites.invite(current_user, @account, @permission_invite.email).deliver
        redirect_to permission_invite_params[:redirect_url], notice: t("permission_invite.invite")
      else
        @permissions = @account.permissions.includes(:user).page params[:page]
        @permission_invites = @account.permission_invites
        @people_count = @account.users.count
        @pending_invites_count = @account.permission_invites.count
        @permission_invites = @account.permission_invites
        @show_modal = true
        render "permission_invites/index"
      end
    end
  end

  def destroy
    @permission_invite.destroy
    redirect_to params[:redirect_url], notice: t("permission_invite.removed")
  end

  private

    def set_permission_invite
      @permission_invite = PermissionInvite.find(params[:id])
    end

    def permission_invite_params
      params.require(:permission_invite).permit(:email, :ref_role_slug, :created_by, :name, :create_user, :do_not_email_user, :updated_by, :permissible_type, :permissible_id, :redirect_url)
    end
end
