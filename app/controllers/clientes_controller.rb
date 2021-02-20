class ClientesController < ApplicationController
  
  before_action :set_cliente, only: %i[ show edit update destroy ]

  # GET /clientes or /clientes.json
  def index
    @clientes = Cliente.all
  end

  # GET /clientes/1 or /clientes/1.json
  def show
    
    @cliente=Cliente.find_by_id(params[:id])
    if @cliente[:id].to_i == params[:id].to_i
      @a = Extrato.all
      @extratos = Hash.new()
      
      count=0
      for i in 0..@a.length-1
        if @a[i]["conta_origem"] == @cliente.conta or @a[i]["conta_destino"] == @cliente.conta
          @extratos[count]=@a[i]
          count=count+1
        end
      end
      
    else
      redirect_to root_path
    end
  end

  def depositar    
    if params["conta"].nil?
    else
      valor=params["valor"].to_f
      conta=params["conta"]
        if valor > 0 and not Cliente.find_by(conta: conta).nil?
          @cliente=Cliente.find_by(conta: conta)
          novo_valor = valor + @cliente["saldo"].to_f  
          @extrato=Extrato.new(tipo: "Depósito", conta_destino: @cliente["conta"], valor: params["valor"].to_f, status: 0)
          respond_to do |format|
            if @extrato.save
              format.html { redirect_to clientes_path, notice: 'Valor depositado com sucesso' }
              format.json { render :show, status: :created, location: @cliente }
            else
              format.html { render :new }
              format.json { render json: @cliente.errors, status: :unprocessable_entity }
            end
          end
        else
          redirect_to depositar_path, notice: "Conta não encontrada"
        end
    end
  end

  def transferir
    
    if current_cliente[:id].to_i == params[:id].to_i
      if not params["conta"].nil?
          id=params["id"].to_i
          conta_origem=current_cliente[:conta]
          valor=params[:valor].to_f
          conta_destino=params[:conta]
          @cliente_origem=Cliente.find_by(conta: conta_origem)
          @cliente_destino=Cliente.find_by(conta: conta_destino)
          

        if not @cliente_destino.nil? and valor > 0 and conta_origem != conta_destino and @cliente_origem["saldo"] >= valor
          novo_valor_origem = @cliente_origem["saldo"].to_f - valor

          respond_to do |format|
            if @cliente_origem.update(password: params[:password], saldo: novo_valor_origem)
              @extrato=Extrato.new(tipo: "Transferência", conta_origem: @cliente_origem["conta"], conta_destino: @cliente_destino["conta"], valor: valor, status: false)
              @extrato.save
              format.html { redirect_to @cliente_origem, notice: 'Valor transferido com sucesso' }
              format.json { render :show, status: :created, location: @cliente_origem }
            else
              format.html { render :new }
              format.json { render json: @cliente_origem.errors, status: :unprocessable_entity }
            end
          end
        else
          redirect_to current_cliente, notice: "Falha na transferência"
        end
      end
      else
        redirect_to current_cliente
      end    
  end

  def sacar
    if current_cliente[:id].to_i == params[:id].to_i
      valor = params[:valor].to_f
      if valor > 0 and current_cliente[:saldo] >= valor
        novo_valor = current_cliente[:saldo] - valor
        respond_to do |format|
          @cliente = Cliente.find_by(email: current_cliente[:email])
          if @cliente.update(password: params[:password], saldo: novo_valor)
            @extrato=Extrato.new(tipo: "Saque", conta_origem: @cliente["conta"], valor: valor, status: true)
            @extrato.save
            format.html { redirect_to @cliente, notice: 'Valor resgatado com sucesso' }
            format.json { render :show, status: :created, location: @cliente }
          else
            format.html { render :new }
            format.json { render json: @cliente.errors, status: :unprocessable_entity }
          end
        end
      end    
    else
      redirect_to current_cliente
    end
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes or /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)
    @cliente[:conta]=10.times.map { rand(10) }.join
    @cliente[:saldo]=0
    extrato=Extrato.new(tipo: '000', conta_origem: @cliente[:conta], conta_destino: '000001', valor: 0, status: true)
    extrato.save
    

    respond_to do |format|
      if @cliente.save and @cliente[:id].to_i != 1
        format.html { redirect_to @cliente, notice: "Cliente was successfully created." }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1 or /clientes/1.json
  def update
    
    respond_to do |format|
      if @cliente.update(cliente_params)
        format.html { redirect_to @cliente, notice: "Cliente was successfully updated." }
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1 or /clientes/1.json
  def destroy
    @cliente.destroy
    respond_to do |format|
      format.html { redirect_to clientes_url, notice: "Cliente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.require(:cliente).permit(:nome, :email, :password, :password_confirmation, :conta, :saldo)
    end
end
