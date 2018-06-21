class PermissionInvitesController < ApplicationController

  before_action :authenticate_user!, :sudo_role_can_add_site_people
  before_action :set_permission_invite, only: [:show, :edit, :update, :destroy]

  def index
    @permissions = @site.permissions.not_hidden.includes(:user).page params[:page]
    @permission_invite = PermissionInvite.new
    @permission_invites = @site.permission_invites
    @pending_invites_count = @site.permission_invites.count
    @people_count = @site.permissions.not_hidden.count
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
        notice = t("permission_invite.invite")
        if @permission_invite.create_user
          new_user = User.new({email: @permission_invite.email,name: @permission_invite.name })
          pass = SecureRandom.hex(10)
          new_user.password = pass
          new_user.password_confirmation = pass
          new_user.skip_confirmation! if @permission_invite.do_not_email_user
          new_user.save
          Permission.create(name: @permission_invite.name, user_id: new_user.id, permissible_type: @permission_invite.permissible_type, permissible_id: @permission_invite.permissible_id, created_by: @permission_invite.created_by, updated_by: @permission_invite.updated_by, ref_role_slug: @permission_invite.ref_role_slug)
          @permission_invite.destroy
        end
        unless @permission_invite.do_not_email_user
          PermissionInvites.invite(current_user, @site, @permission_invite.email).deliver
        else
          if @permission_invite.create_user
            notice = t("permission_invite.noinvite")
          else
            notice = t("permission_invite.nouser_noinvite")
          end
        end
        redirect_to permission_invite_params[:redirect_url], notice: notice
      else
        @permissions = @site.permissions.includes(:user).page params[:page]
        @permission_invites = @site.permission_invites
        @people_count = @site.users.count
        @pending_invites_count = @site.permission_invites.count
        @permission_invites = @site.permission_invites
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
