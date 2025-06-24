class CartController < ApplicationController
  include CartSession
  
  before_action :find_cart, except: [:create]
  before_action :validate_quantity, only: [:create, :update_item]

  def create
    create_cart_if_needed

    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    service = CartService.new(@cart)
    result = service.add_product(product_id, quantity)

    if result[:success]
      render json: service.to_json
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def show
    service = CartService.new(@cart)
    render json: service.to_json
  end

  def update_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    service = CartService.new(@cart)
    result = service.update_product_quantity(product_id, quantity)

    if result[:success]
      render json: service.to_json
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def destroy
    product_id = params[:product_id]

    service = CartService.new(@cart)
    result = service.remove_product(product_id)

    if result[:success]
      render json: service.to_json
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  private

  def find_cart
    @cart = Cart.find_by(id: session[:cart_id])
    unless @cart
      render json: { error: "Carrinho não encontrado" }, status: :not_found
    end
  end

  def validate_quantity
    quantity = params[:quantity].to_i
    if quantity <= 0
      render json: { error: "Quantidade deve ser maior que zero" }, status: :unprocessable_entity
    end
  end
end
