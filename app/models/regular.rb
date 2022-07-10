class Regular < ApplicationRecord
    has_many :regular_products
    belongs_to :user

    validates :regular_number, numericality: { in: 1..4 }
end
