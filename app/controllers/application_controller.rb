class ApplicationController < ActionController::Base
  Time.zone = 'Brasilia'
helper_method :current_cliente
  def current_cliente
    if session[:cliente_id]
      @current_cliente ||= Cliente.find(session[:cliente_id])
    else
      @current_cliente = nil
    end
  end
end
