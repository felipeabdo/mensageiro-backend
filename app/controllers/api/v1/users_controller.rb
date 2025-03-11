class Api::V1::UsersController < ApplicationController
  before_action :set_current_user

  def index
    users = User.where.not(id: @current_user.id)
    render json: users
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def current_user_info
    render json: @current_user
  end

  private

  def set_current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
    head :unauthorized unless @current_user
  end
end