require 'rails_helper'

RSpec.describe 'Products', type: :request do
  # Initialize the test data
  let!(:shop) { create(:shop) }
  let!(:products) { create_list(:product, 20, shop_id: shop.id) }
  let(:shop_id) { shop.id }
  let(:id) { products.first.id }

  # Test suite for GET /api/v1/shops/:shop_id/products
  describe 'GET /api/v1/shops/:shop_id/products' do
    before { get api_v1_shop_products_path(shop_id: shop_id) }

    context 'when shop exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all products' do
        expect(json.size).to eq(20)
      end
    end

    context 'when shop does not exist' do
      let(:shop_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Shop/)
      end
    end
  end

  # Test suite for GET /api/v1/shops/:shop_id/products/:id
  describe 'GET /api/v1/shops/:shop_id/products/:id' do
    before { get "/api/v1/shops/#{shop_id}/products/#{id}" }

    context 'when product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/products
  describe 'POST /api/v1/shops/:shop_id/products' do
    let(:cost) { Faker::Number.decimal(2) }
    let(:valid_attributes) { { product: { name: 'taco', cost: cost, shop_id: shop_id } } }

    context 'when request attributes are valid' do
      before { post api_v1_shop_products_path(shop_id: shop_id), params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post api_v1_shop_products_path(shop_id: shop_id), params: { product: {wrong: 'idk'} } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/{\"shop\":\[\"must exist\"\],\"name\":\[\"can't be blank\"\],\"cost\":\[\"can't be blank\"\]}/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/products/:id
  describe 'PUT /api/v1/shops/:shop_id/products/:id' do
    let(:valid_attributes) { { product: { name: 'Mozart Music' } } }

    before { put "/api/v1/shops/#{shop_id}/products/#{id}", params: valid_attributes }

    context 'when product exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end

      it 'updates the product' do
        updated_product = Product.find(id)
        expect(updated_product.name).to match(/Mozart/)
      end
    end

    context 'when the product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite for DELETE /api/v1/shops/:id
  describe 'DELETE /api/v1/shops/:id' do
    before { delete "/api/v1/shops/#{shop_id}/products/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
