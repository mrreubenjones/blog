class CallbacksController < ApplicationController

  def twitter
    twitter_data = request.env['omniauth.auth']

    # Search for user with the given provider and UID
    user = User.find_from_oauth(twitter_data)

    # Create the user if user is not found
    user ||= User.create_from_oauth(twitter_data)

    # Sign in the user
    session[:user_id] = user.id
    redirect_to root_path, notice: "You're signed in with Twitter"
  end

end

