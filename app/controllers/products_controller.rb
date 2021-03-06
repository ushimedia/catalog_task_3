class ProductsController < ApplicationController
  before_action :set_product, only: %i[ detail show edit update destroy ]

  # GET /products or /products.json
  def index
    @q = Product.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @products = @q.result.where(user_id: current_user.id, discarded_at: nil)

    
  end

  

  def import
    if params[:file].present?
      if Product.csv_format_check(params[:file]).present?
        redirect_to products_path, notice: "エラーが発生したため処理を中断しました。#{Product.csv_format_check(params[:file])}"
      else
        message = Product.import_save(params[:file], current_user.id)
        redirect_to products_path, notice: "インポート商品登録が完了しました。#{message}"
      end
    else
      redirect_to products_path, notice: "インポート処理が失敗しました。ファイルを選択し直してください。"
    end
  end

  

  # GET /products/1 or /products/1.json
  def show
    @regular = Regular.where(user_id: current_user.id)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def detail
  end



  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: "商品登録が完了しました。" }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: "商品情報が正常に更新されました。" }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.discard

    respond_to do |format|
      format.html { redirect_to products_url, notice: "商品は正常に削除されました。" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
      :name, 
      :price, 
      :stock, 
      :status,
      :description,
      :image,
      images_attributes: [:src]
      )
    end
end
