class SessionsController < ApplicationController
  
  def new
  end

  def create
    @cliente = Cliente.find_by_email(params[:email])
    if @cliente && @cliente.authenticate(params[:password])
      atualiza
      session[:cliente_id] = @cliente.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Name, Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:cliente_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  def atualiza
    @a = Extrato.all
    @extratos = Hash.new()
    
    count=0
    for i in 0..@a.length-1
      if @a[i]["conta_destino"] == @cliente[:conta]
        @extratos[count]=@a[i]
        count=count+1
      end
    end
    
    for i in 0..@extratos.length-1
      if @extratos[i][:status] == false and (@extratos[i][:tipo]=="Depósito" or @extratos[i][:tipo]=="Transferência")
        novo_valor = @cliente[:saldo]+@extratos[i][:valor]
        @cliente.update(password: params[:password], saldo: novo_valor)
        @extratos[i].update(status: true)
      end
    end
  end
end
