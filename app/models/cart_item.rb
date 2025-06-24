class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :product_id, uniqueness: { scope: :cart_id, message: "já está no carrinho" }

  def total_price
    product.unit_price.to_f * quantity
  end

  def increase_quantity(amount = 1)
    update(quantity: quantity + amount)
  end

  def decrease_quantity(amount = 1)
    new_quantity = quantity - amount
    if new_quantity <= 0
      destroy
    else
      update(quantity: new_quantity)
    end
  end
end
