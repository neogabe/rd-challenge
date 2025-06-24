class CartService
  attr_reader :cart

  def initialize(cart)
    @cart = cart
  end

  def add_product(product_id, quantity)
    product = Product.find_by(id: product_id)
    return { success: false, error: "Produto não encontrado" } unless product

    cart_item = @cart.cart_items.find_by(product_id: product_id)
    
    if cart_item
      cart_item.increase_quantity(quantity)
    else
      @cart.cart_items.create(product: product, quantity: quantity)
    end

    { success: true, cart: @cart }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  def update_product_quantity(product_id, quantity)
    cart_item = @cart.cart_items.find_by(product_id: product_id)
    return { success: false, error: "Produto não está no carrinho" } unless cart_item

    cart_item.update(quantity: quantity)
    { success: true, cart: @cart }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  def remove_product(product_id)
    cart_item = @cart.cart_items.find_by(product_id: product_id)
    return { success: false, error: "Produto não está no carrinho" } unless cart_item

    cart_item.destroy
    { success: true, cart: @cart }
  end

  def calculate_total
    @cart.total_price
  end

  def products_list
    @cart.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.unit_price.to_f,
        total_price: item.total_price
      }
    end
  end

  def to_json
    {
      id: @cart.id,
      products: products_list,
      total_price: calculate_total,
      item_count: @cart.item_count
    }
  end
end 