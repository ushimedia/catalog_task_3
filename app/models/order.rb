class Order < ApplicationRecord
    include Discard::Model
  
    has_many :cart_item, dependent: :destroy
    has_many :order_products
    belongs_to :user
    has_many :products, through: :order_products
    has_many :cart_items, through: :products

    
    enum status: { 発注済: 0, 店舗確認中: 1, 発送準備中: 2, 発送済: 3}
    
    
    
end
