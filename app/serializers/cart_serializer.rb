class CartSerializer
  include JSONAPI::Serializer

  attributes :id, :total_price, :abandoned

  attribute :products do |cart|
    cart.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.unit_price.to_f,
        total_price: (item.product.unit_price.to_f * item.quantity).to_f
      }
    end
  end

  def self.serialize_cart(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.unit_price.to_f,
          total_price: (item.product.unit_price.to_f * item.quantity).to_f
        }
      end,
      total_price: cart.cart_items.includes(:product).sum { |item| item.product.unit_price.to_f * item.quantity }
    }
  end
end 