class Product < ApplicationRecord
    has_many :cart_products, dependent: :destroy

    enum status: { 出品中: true, 取り下げ中: false }

end
