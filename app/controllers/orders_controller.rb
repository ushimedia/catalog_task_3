class OrdersController < ApplicationController
  before_action :set_order, only: %i[ received_show show edit update destroy ]

  # GET /orders or /orders.json
  def index
   @q = Product.ransack(params[:q])
   @q.sorts = 'stock desc' if @q.sorts.empty?
   @products = @q.result.where(status: true, discarded_at: nil).page(params[:page]).per(20)
   @cart_items = current_cart.cart_items.includes([:product])
   @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
   @total_item = @cart_items.inject(0) { |sum, item| sum + item.quantity }
  

  
  end





  def history
    @q = Order.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @orders = @q.result.where(user_id: current_user.id, discarded_at: nil)
    

  end

  def received
    @q = Order.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @orders = @q.result.where(discarded_at: nil)
    
  
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_orders_csv(@orders)
      end
    end
    
    

  end

  def received_show
  
    @order_product = OrderProduct.where(order_id: params[:id])
  end


  # GET /orders/1 or /orders/1.json
  def show
    @order_product = OrderProduct.where(order_id: params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
      cart_items = current_cart.cart_items.all
      @order = current_user.orders.new(order_params)
    begin
      ActiveRecord::Base.transaction do
        @order.save!
          cart_items.each do |cart|
            order_product = OrderProduct.new
            order_product.product_id = cart.product_id
            order_product.order_id = @order.id
            order_product.order_quantity = cart.quantity
            order_product.order_price = cart.product.price
            order_product.save!
            @product = Product.find(order_product.product_id)
            @product.stock -= order_product.order_quantity 
            @product.save!
          end
        redirect_to root_path
        flash[:notice] = '?????????????????????????????????'
        cart_items.destroy_all
    end
    rescue
    flash[:notice] = '???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'
    @order = Order.new(order_params)
      render :new
    end
  end
  


  
def check
  @order = Order.new(order_params)
  if params[:order][:address_number] == "1"
    @order.name = current_user.name 
    @order.address = current_user.company_address
  elsif params[:order][:address_number] == "2"
    if Address.exists?(name: params[:order][:registered])
      @order.name = Address.find(params[:order][:registered]).name
      @order.address = Address.find(params[:order][:registered]).address
    else
      render :new
    end
  elsif params[:order][:address_number] == "3"
    address_new = current_user.addresses.new(address_params)
    if address_new.save 
    else
      render :new
    end
  else
    redirect_to root_path 
  end
  @cart_items = current_cart.cart_items.all 
  @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params) && @order.status == "?????????"
        DeliveryMailer.with(order: @order, user: current_user).delivery_email.deliver_now
        format.html { redirect_to received_orders_path, notice: "???????????????????????????????????????" }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { redirect_to received_orders_path, notice: "???????????????????????????????????????" }
        format.json { render :show, status: :ok, location: @order }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.discard

    respond_to do |format|
      format.html { redirect_to received_orders_path, notice: "?????????????????????????????????" }
      format.json { head :no_content }
    end
  end

  private

  
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
    params.require(:order).permit(:name, :address, :total_price, :status)
  end
  
  def address_params
    params.require(:order).permit(:name, :address)
  end

  def send_orders_csv(orders)
    bom = "\uFEFF"
    csv_data = CSV.generate(bom) do |csv|
      column_names = %w(???????????? ????????? ???????????? ????????? ???????????? ?????????????????????)
      csv << column_names
      orders.each do |order|
        column_values = [
          order.user.name,
          order.created_at.strftime("%-m???%-d???"),
          order.created_at.strftime("%-H???%-M???"),
          order.address,
          order.total_price.to_s(:delimited),
          order.status,
         
        ]
        csv << column_values
      end
    end
    send_data(csv_data, filename: "????????????.csv")
  end

end
