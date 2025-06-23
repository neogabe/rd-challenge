class CartController < ApplicationController
  def create
    @cart = Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(abandoned: false)
      session[:cart_id] = @cart.id
    end

    #pegar os parametros do payload
    product_id = params[:product_id]
    quantity = params[:quantity]

    #buscar o produtio
    product = Product.find_by(id: product_id)
    return render json: { error: "Produto não encontrado" }, status: :not_found unless product

    #verificar se o produto já está no carrinho
    cart_item = @cart.cart_items.find_by(product_id: product_id)
    if cart_item
      cart_item.quantity += quantity
      cart_item.save
    else
      @cart.cart_items.create(product: product, quantity: quantity)
    end

    #monta a lista de produtos do carrinho
    products = @cart.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.unit_price.to_f,
        total_price: (item.product.unit_price.to_f * item.quantity).to_f
      }
    end

    #calcula o total do carrinho
    total_price = products.sum { |p| p[:total_price] }

    #retorna o payload
    render json: {
      id: @cart.id,
      products: products,
      total_price: total_price
    }
  end
end