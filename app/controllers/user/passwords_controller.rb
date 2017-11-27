class User::PasswordsController < Devise::PasswordsController
    layout "three_column_grid"

    def new
        super
    end
end
