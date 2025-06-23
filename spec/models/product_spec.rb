require 'rails_helper'

RSpec.describe Product, type: :model do
  it "é válido com nome e preço" do
    product = Product.new(name: "Produto Teste", unit_price: 10.0)
    expect(product).to be_valid
  end

  it "não é válido sem nome" do
    product = Product.new(unit_price: 10.0)
    expect(product).not_to be_valid
  end

  it "não é válido sem preço" do
    product = Product.new(name: "Produto Teste")
    expect(product).not_to be_valid
  end
end