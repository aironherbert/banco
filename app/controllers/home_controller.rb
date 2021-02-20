class HomeController < ApplicationController
  
  def index
    if Cliente.first.nil?
      cliente=Cliente.new(nome: 'Exemplo', email: 'exemplo@exemplo.com', conta: '000000', password: '123456', password_confirmation: '123456')
      cliente.save
    end
  end
end
