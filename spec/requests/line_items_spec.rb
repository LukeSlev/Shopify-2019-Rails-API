require 'rails_helper'

RSpec.describe 'LineItems API', type: :request do
  # Initialize the test data
  let(:user) { create(:user) }

  let!(:shop) { create(:shop, created_by: user.id) }
  let!(:order) { create(:order, shop_id: shop.id) }
  let!(:product) { create(:product, shop_id: shop.id) }
  let!(:line_items) { create_list(:line_item, 20, order_id: order.id, product_id: product.id) }
  let(:shop_id) { shop.id }
  let(:order_id) { order.id }
  let(:product_id) { product.id }
  let(:id) { line_items.first.id }

  # authorize request
  let(:headers) { valid_headers }

  # Test suite for GET /api/v1/shops/:shop_id/orders/:order_id/line_items
  describe 'GET /api/v1/shops/:shop_id/orders/:order_id/line_items' do
    before { get api_v1_shop_order_line_items_path(shop_id: shop_id, order_id: order_id), params: {}, headers: headers }

    context 'when shop exists' do
      context 'when the order exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all line_items' do
          expect(json.size).to eq(20)
        end
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

    context 'when order does not exist' do
      let(:order_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Order/)
      end
    end
  end

  # Test suite for GET /api/v1/shops/:shop_id/orders/:order_id/line_items/:id
  describe 'GET /api/v1/shops/:shop_id/orders/:order_id/line_items/:id' do
    before { get "/api/v1/shops/#{shop_id}/orders/#{order_id}/line_items/#{id}", params: {}, headers: headers }

    context 'when product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when line item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find LineItem/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/orders/:order_id/line_items
  describe 'POST /api/v1/shops/:shop_id/orders/:order_id/line_items' do
    let(:valid_attributes) { { line_item: { quantity: Faker::Number.number(2), product_id: product_id } }.to_json }

    context 'when request attributes are valid' do
      before { post api_v1_shop_order_line_items_path(shop_id: shop_id, order_id: order_id), params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_params) { { line_item: { name: 'idk', product_id: product_id} }.to_json }
      before { post api_v1_shop_order_line_items_path(shop_id: shop_id, order_id: order_id), params: invalid_params, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/{\"quantity\":\[\"can't be blank\"\]}/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/orders/:order_id/line_items/:id
  describe 'PUT /api/v1/shops/:shop_id/orders/:order_id/line_items/:id' do
    let(:quantity) { Faker::Number.number(2).to_i }
    let(:valid_attributes) { { line_item: { quantity: quantity } }.to_json }

    before { put "/api/v1/shops/#{shop_id}/orders/#{order_id}/line_items/#{id}", params: valid_attributes, headers: headers }

    context 'when order exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the order' do
        updated_line_item = LineItem.find(id)
        expect(updated_line_item.quantity).to eq(quantity)
      end
    end

    context 'when the product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find LineItem/)
      end
    end
  end

  # Test suite for DELETE /api/v1/shops/:id
  describe 'DELETE /api/v1/shops/:id' do
    before { delete "/api/v1/shops/#{shop_id}/orders/#{order_id}/line_items/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
