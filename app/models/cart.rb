class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :abandoned, inclusion: { in: [true, false], message: "deve ser verdadeiro ou falso" }

  scope :active, -> { where(abandoned: false) }
  scope :abandoned, -> { where(abandoned: true) }

  def total_price
    cart_items.includes(:product).sum { |item| item.product.unit_price.to_f * item.quantity }
  end

  def item_count
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end

  def mark_as_abandoned!
    update!(abandoned: true)
  end

  def reactivate!
    update!(abandoned: false)
  end
end
