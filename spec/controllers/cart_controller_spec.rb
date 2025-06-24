require 'rails_helper'

RSpec.describe CartController, type: :controller do
  describe "POST #create" do
    let!(:product) { Product.create(name: "Produto Teste", unit_price: 10.0) }

    it "adiciona um produto ao carrinho e retorna o payload correto" do
      post :create, params: { product_id: product.id, quantity: 2 }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["products"].first["id"]).to eq(product.id)
      expect(json["products"].first["quantity"]).to eq(2)
      expect(json["total_price"]).to eq(20.0)
    end

    it "rejeita quantidade zero" do
      post :create, params: { product_id: product.id, quantity: 0 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Quantidade deve ser maior que zero")
    end

    it "rejeita quantidade negativa" do
      post :create, params: { product_id: product.id, quantity: -1 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Quantidade deve ser maior que zero")
    end
  end

  describe "GET #show" do
    let!(:product) { Product.create(name: "Produto Teste", unit_price: 10.0) }

    it "retorna os itens do carrinho corretamente" do
      #add um produto ao carrinho via POST
      post :create, params: { product_id: product.id, quantity: 2 }
      get :show

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["products"].first["id"]).to eq(product.id)
      expect(json["products"].first["quantity"]).to eq(2)
      expect(json["total_price"]).to eq(20.0)
    end
  end

  describe "POST #add_item" do
    let!(:product) { Product.create(name: "Produto Teste", unit_price: 10.0) }

    it "altera a quantidade de um produto no carrinho" do
      post :create, params: { product_id: product.id, quantity: 2 }
      post :add_item, params: { product_id: product.id, quantity: 5 }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["products"].first["quantity"]).to eq(5)
      expect(json["total_price"]).to eq(50.0)
    end

    it "rejeita quantidade zero no add_item" do
      post :create, params: { product_id: product.id, quantity: 2 }
      post :add_item, params: { product_id: product.id, quantity: 0 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Quantidade deve ser maior que zero")
    end

    it "rejeita quantidade negativa no add_item" do
      post :create, params: { product_id: product.id, quantity: 2 }
      post :add_item, params: { product_id: product.id, quantity: -1 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Quantidade deve ser maior que zero")
    end
  end

  describe "DELETE #destroy" do
    let!(:product) { Product.create(name: "Produto Teste", unit_price: 10.0) }

    it "remove um produto do carrinho" do
      post :create, params: { product_id: product.id, quantity: 2 }
      delete :destroy, params: { product_id: product.id }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["products"]).to be_empty
      expect(json["total_price"]).to eq(0)
    end
  end
end