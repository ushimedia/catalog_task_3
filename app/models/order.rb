class Order < ApplicationRecord
    has_many :cart_item, dependent: :destroy
end
