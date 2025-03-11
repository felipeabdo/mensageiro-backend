class Api::V1::MessagesController < ApplicationController
  before_action :set_current_user

  def index
    if params[:user_id]
      messages = Message.where(
        "(sender_id = :current_user AND receiver_id = :other_user) OR 
        (sender_id = :other_user AND receiver_id = :current_user)",
        current_user: @current_user.id,
        other_user: params[:user_id]
      )
      .includes(:sender, :receiver)
      .order(created_at: :asc)
    else
      messages = Message.where(
        "(sender_id = :user_id AND deleted_for_sender = false) OR 
        (receiver_id = :user_id AND deleted_for_receiver = false)",
        user_id: @current_user.id
      )
      .where(deleted_for_all: false)
      .includes(:sender, :receiver)
      .order(created_at: :asc)
    end

    render json: messages, include: [:sender, :receiver]
  end

  def create
    message = @current_user.sent_messages.new(message_params)
    
    if message.save
      render json: message, include: [:sender, :receiver], status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    message = Message.find(params[:id])
    
    if message.sender_id == @current_user.id
      case params[:delete_for]
      when "all"
        message.update!(deleted_for_all: true)
      when "me"
        message.update!(deleted_for_sender: true)
      when "permanent"
        message.destroy! 
        return head :no_content
      end
    else
      message.update!(deleted_for_receiver: true)
    end
  
    render json: message.reload
  end

  def restore
    message = Message.find(params[:id])
    
    if message.sender_id == @current_user.id
      message.update!(
        deleted_for_all: false,
        deleted_for_sender: false
      )
    else
      message.update!(deleted_for_receiver: false)
    end

    render json: message
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content)
  end

  def set_current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Token ausente" }, status: :unauthorized unless token

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError
      render json: { error: "Token inválido" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end
  end
end