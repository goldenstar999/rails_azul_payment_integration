class AzulsController < ApplicationController
  before_action :set_azul, only: [:show, :edit, :update, :destroy]

  # GET /azuls
  # GET /azuls.json
  def index
    @azuls = Azul.all
  end

  # GET /azuls/1
  # GET /azuls/1.json
  def show
  end

  # GET /azuls/new
  def new
    @azul = Azul.new
  end

  # GET /azuls/1/edit
  def edit
  end

  # POST /azuls
  # POST /azuls.json
  def create
    @azul = Azul.new(azul_params)

    respond_to do |format|
      if @azul.save
        format.html { redirect_to @azul, notice: 'Azul was successfully created.' }
        format.json { render :show, status: :created, location: @azul }
      else
        format.html { render :new }
        format.json { render json: @azul.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /azuls/1
  # PATCH/PUT /azuls/1.json
  def update
    respond_to do |format|
      if @azul.update(azul_params)
        format.html { redirect_to @azul, notice: 'Azul was successfully updated.' }
        format.json { render :show, status: :ok, location: @azul }
      else
        format.html { render :edit }
        format.json { render json: @azul.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /azuls/1
  # DELETE /azuls/1.json
  def destroy
    @azul.destroy
    respond_to do |format|
      format.html { redirect_to azuls_url, notice: 'Azul was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def page_forwarding_mode
    @azul = Azul.first
    if !@azul.present?
      @azul = Azul.new
    end

  end

  def forward_to_azul_payment_page
    puts "params: #{params.inspect}"

    currency = params[:currency]
    order_number = params[:order_number]
    # amount = params[:amount]
    # itbis = params[:itbis]

    itbis = '%.2f' % params[:itbis].to_f.round(2)
    amount = '%.2f' % params[:amount].to_f.round(2)
    amount = '%.2f' %  (amount.to_f + itbis.to_f).round(2)

    auth_hash =  "#{params[:azul][:merchant_id]}#{params[:azul][:merchant_name]}#{params[:azul][:merchant_type]}#{currency}#{order_number}#{amount}#{params[:azul][:approved_url]}#{params[:azul][:declined_url]}#{params[:azul][:cancel_url]}#{params[:azul][:response_post_url]}#{params[:azul][:auth_key]}"
    auth_hash = Digest::SHA512.hexdigest auth_hash
    puts "#{amount}, #{itbis}, #{order_number}, #{currency}, #{params[:azul][:merchant_id]}, #{auth_hash}"
    # redirect_to "https://pruebas.azul.com.do/PaymentPage/"
    #
    # form_with(scope: :post, url: params[:azul][:url_azul]) do |form|
    #   form.text_field :MerchantId, params[:azul][:merchant_id]
    #   form.text_field :MerchantName, params[:azul][:merchant_name]
    #   form.text_field :MerchantType, params[:azul][:merchant_type]
    #   form.text_field :CurrencyCode, params[:currency]
    #   form.text_field :itbis, params[:itbis]
    #   form.text_field :OrderNumber, params[:order_number]
    #   form.text_field :Amount, params[:amount]
    #   form.text_field :ApprovedUrl, params[:azul][:approved_url]
    #   form.text_field :DeclinedUrl, params[:azul][:declined_url]
    #   form.text_field :CancelUrl, params[:azul][:cancel_url]
    #   form.text_field :ResponsePostUrl, params[:azul][:response_post_url]
    #   form.text_field :AuthHash, auth_hash
    #
    #   form.submit
    # end
  end

  def api_mode
    @azul = Azul.first
    if !@azul.present?
      @azul = Azul.new
    end
  end

  def approved
    puts "==== params: #{params.inspect} ===="
  end

  def canceled
    puts "==== params: #{params.inspect} ===="
  end

  def declined
    puts "==== params: #{params.inspect} ===="
  end

  def response_post
    puts "==== params: #{params.inspect} ===="
  end

  def get_auth_hash
    custom_field_1 = 1
    custom_field_1_label = 'test1'
    custom_field_1_value = 't1'
    custom_field_2 = 1
    custom_field_2_label = 'test2'
    custom_field_2_value = 't2'
    auth_hash =  "#{params[:merchant_id]}#{params[:merchant_name]}#{params[:merchant_type]}#{params[:currency]}#{params[:order_number]}#{params[:amount]}#{params[:approved_url]}#{params[:declined_url]}#{params[:cancel_url]}#{params[:response_post_url]}#{custom_field_1}#{custom_field_1_label}#{custom_field_1_value}#{custom_field_2}#{custom_field_2_label}#{custom_field_2_value}#{params[:auth_key]}"
    auth_hash = Digest::SHA512.hexdigest auth_hash
    render json: {auth_hash: auth_hash}
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_azul
      @azul = Azul.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def azul_params
      params.require(:azul).permit(:merchant_id, :merchant_type, :merchant_name, :auth_key, :url_azul, :approved_url, :declined_url, :cancel_url, :response_post_url, :custom_field_1, :custom_field_1_label, :custom_field_1_value, :custom_field_2, :custom_field_2_label, :custom_field_2_value)
    end
end