class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
    @products = Product.where(status: true).page(params[:page])

   @cart_items = current_cart.cart_items.includes([:product])
   @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
   @total_item = @cart_items.inject(0) { |sum, item| sum + item.quantity }

  end


  def history
    @orders = Order.all
    

  end

  def received
    @orders = Order.all
    

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
  def create # Order に情報を保存します
    cart_items = current_cart.cart_items.all
  # ログインユーザーのカートアイテムをすべて取り出して cart_items に入れます
    @order = current_user.orders.new(order_params)
  # 渡ってきた値を @order に入れます
    if @order.save
  # ここに至るまでの間にチェックは済ませていますが、念の為IF文で分岐させています
      cart_items.each do |cart|
  # 取り出したカートアイテムの数繰り返します
  # order_item にも一緒にデータを保存する必要があるのでここで保存します
        order_product = OrderProduct.new
        order_product.product_id = cart.product_id
        order_product.order_id = @order.id
        order_product.order_quantity = cart.quantity
  # 購入が完了したらカート情報は削除するのでこちらに保存します
        order_product.order_price = cart.product.price
  # カート情報を削除するので item との紐付けが切れる前に保存します
        order_product.save
      end
      redirect_to root_path
      flash[:notice] = '注文が送信されました。'
      cart_items.destroy_all

  # ユーザーに関連するカートのデータ(購入したデータ)をすべて削除します(カートを空にする)
    else
      @order = Order.new(order_params)
      render :new
    end
  end

  # new 画面から渡ってきたデータをユーザーに確認してもらいます
def check
  @order = Order.new(order_params)
# new 画面から渡ってきたデータを @order に入れます
  if params[:order][:address_number] == "1"
# view で定義している address_number が"1"だったときにこの処理を実行します
# form_with で @order で送っているので、order に紐付いた address_number となります。以下同様です
# この辺の紐付けは勉強不足なので gem の pry-byebug を使って確認しながら行いました
    @order.name = current_user.name # @order の各カラムに必要なものを入れます
    @order.address = current_user.company_address
  elsif params[:order][:address_number] == "2"
# view で定義している address_number が"2"だったときにこの処理を実行します
    if Address.exists?(name: params[:order][:registered])
# registered は viwe で定義しています
      @order.name = Address.find(params[:order][:registered]).name
      @order.address = Address.find(params[:order][:registered]).address
    else
      render :new
# 既存のデータを使っていますのでありえないですが、万が一データが足りない場合は new を render します
    end
  elsif params[:order][:address_number] == "3"
# view で定義している address_number が"3"だったときにこの処理を実行します
    address_new = current_user.addresses.new(address_params)
    if address_new.save # 確定前(確認画面)で save してしまうことになりますが、私の知識の限界でした
    else
      render :new
# ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻します
    end
  else
    redirect_to 遷移したいページ # ありえないですが、万が一当てはまらないデータが渡ってきた場合の処理です
  end
  @cart_items = current_cart.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
  @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
# 合計金額を出す処理です sum_price はモデルで定義したメソッドです
end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
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
end
