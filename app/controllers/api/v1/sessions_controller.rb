class Api::V1::SessionsController < ApplicationController
  def create
    puts "Params recebidos: #{params.inspect}" # Adicione este log
    user = User.find_by(id: params[:user_id])
    if user
      puts "Usuário encontrado: #{user.inspect}"
      token = JwtService.encode({ user_id: user.id })
      puts "Token gerado: #{token}"
      render json: { token: token }
    else
      puts "Usuário não encontrado"
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    end
  end
end