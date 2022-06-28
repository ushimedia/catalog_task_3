class Product < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    
    has_many :order_products, dependent: :destroy
    
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true
    
    enum status: { 出品中: true, 取り下げ中: false }

end
