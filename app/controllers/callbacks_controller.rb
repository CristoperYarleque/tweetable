class CallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_hash = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth_hash)
    uri = URI.parse(auth_hash.info.image)
    avatar = Net::HTTP.get(uri)
    @user.avatar.attach(io: StringIO.new(avatar), filename: "user_avatar")
    sign_in_and_redirect @user
  end
end
