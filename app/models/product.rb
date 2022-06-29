class Product < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    
    has_many :order_products, dependent: :destroy
    has_many :orders, through: :order_products

   
    
    enum status: { 出品中: true, 取り下げ中: false }

    mount_uploader :image, ImageUploader

end
