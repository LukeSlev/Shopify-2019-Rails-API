# app/controllers/authentication_controller.rb
class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  # return auth token once user is authenticated
  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    render json: {auth_token: auth_token}, response: :ok
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
