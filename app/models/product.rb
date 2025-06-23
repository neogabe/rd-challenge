class Product < ApplicationRecord
  has_many :cart_items
  has_many :carts, through: :cart_items

  validates :name, presence: true
  validates :unit_price, presence: true
end
