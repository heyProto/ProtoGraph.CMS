class AuthenticationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @authentications = current_user.authentications
  end
end
