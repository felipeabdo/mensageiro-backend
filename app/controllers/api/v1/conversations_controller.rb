class Api::V1::ConversationsController < ApplicationController
  before_action :set_current_user

  def destroy
    if params[:delete_for] == "all"
      Message.where(
        "(sender_id = :user_id AND receiver_id = :other_user) OR 
        (sender_id = :other_user AND receiver_id = :user_id)",
        user_id: @current_user.id,
        other_user: params[:user_id]
      ).update_all(deleted_for_all: true)
    else
      Message.where(
        sender_id: @current_user.id,
        receiver_id: params[:user_id]
      ).update_all(deleted_for_sender: true)
    end

    render json: { status: "success" }
  end

  private

  def set_current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Não autorizado" }, status: :unauthorized unless token

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue StandardError => e
      render json: { error: "Autenticação falhou: #{e.message}" }, status: :unauthorized
    end
  end
end