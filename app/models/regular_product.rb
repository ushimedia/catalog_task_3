class RegularProduct < ApplicationRecord

    belongs_to :product
    belongs_to :regular, dependent: :destroy
end
