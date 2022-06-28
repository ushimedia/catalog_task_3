class CartItem < ApplicationRecord
    belongs_to :product, dependent: :destroy
    belongs_to :cart, dependent: :destroy


  
    # カート内の商品合計に利用
    def sum_of_price
      product.price * quantity
    end
end
