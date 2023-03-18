module Api
  class UsersController < ApiController
    skip_before_action :authorize, only: :create

    def create
      user = User.new(name: params[:name], username: params[:username], email: params[:email],
                      password: params[:password])
      if user.save
        render json: user, status: :ok
      else
        respond_unauthorized("could not be created, username already exists")
      end
    end
  end
end
