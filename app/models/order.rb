class Order < ApplicationRecord
    has_many :cart_item, dependent: :destroy
    has_many :order_products
    belongs_to :user
    enum status: { 発注済: 0, 店舗確認中: 1, 発送準備中: 2, 発送済: 3}
   
    has_many :products, through: :order_products
end
