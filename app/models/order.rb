class Order < ApplicationRecord
    has_many :cart_item, dependent: :destroy
    has_many :order_products
end
