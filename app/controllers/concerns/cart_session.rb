module CartSession
  extend ActiveSupport::Concern

  private

  def find_cart
    @cart = Cart.find_by(id: session[:cart_id])
    unless @cart
      render json: { error: "Carrinho não encontrado" }, status: :not_found
    end
  end

  def create_cart_if_needed
    @cart = Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(abandoned: false)
      session[:cart_id] = @cart.id
    end
  end

  def validate_quantity
    quantity = params[:quantity].to_i
    if quantity <= 0
      render json: { error: "Quantidade deve ser maior que zero" }, status: :unprocessable_entity
    end
  end

  def validate_product_exists
    product = Product.find_by(id: params[:product_id])
    unless product
      render json: { error: "Produto não encontrado" }, status: :not_found
    end
  end
end 