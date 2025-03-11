class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(id: params[:user_id])
    if user
      token = JwtService.encode({ user_id: user.id })
      render json: { token: token }
    else
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    end
  end
end