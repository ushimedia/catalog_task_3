class RegularProductsController < ApplicationController
    before_action :set_regularproduct, only: %i[ show edit update destroy ]
    def destroy
        @regular_product.destroy
    
        respond_to do |format|
          format.html { redirect_to regulars_url, notice: "リストは正常に削除されました。" }
          format.json { head :no_content }
        end
      end

      def update
        
        respond_to do |format|
          if @regular_product.update(regularproduct_params)
            format.html { redirect_to regulars_path, notice: "商品個数が正常に更新されました。" }
            format.json { render :show, status: :ok, location: @product }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @regular_product.errors, status: :unprocessable_entity }
          end
        end
      end
      private

  
      # Use callbacks to share common setup or constraints between actions.
      def set_regularproduct
        @regular_product = RegularProduct.find(params[:id])
      end
      def regularproduct_params
        params.require(:regular_product).permit(:regular_quantity)
      end
end
