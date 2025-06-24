require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { Cart.create(abandoned: false) }
  let(:product) { Product.create(name: "Produto Teste", unit_price: 10.0) }

  describe "validações" do
    it "é válido com quantidade positiva" do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 5)
      expect(cart_item).to be_valid
    end

    it "não é válido sem quantidade" do
      cart_item = CartItem.new(cart: cart, product: product, quantity: nil)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("não pode ficar em branco")
    end

    it "não é válido com quantidade zero" do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 0)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("deve ser maior que 0")
    end

    it "não é válido com quantidade negativa" do
      cart_item = CartItem.new(cart: cart, product: product, quantity: -1)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("deve ser maior que 0")
    end

    it "não é válido com quantidade decimal" do
      cart_item = CartItem.new(cart: cart, product: product, quantity: 1.5)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("deve ser um número inteiro")
    end
  end

  describe "associações" do
    it "pertence a um carrinho" do
      expect(CartItem.reflect_on_association(:cart).macro).to eq :belongs_to
    end

    it "pertence a um produto" do
      expect(CartItem.reflect_on_association(:product).macro).to eq :belongs_to
    end
  end
end 