require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  # Initialize the test data
  let!(:shop) { create(:shop) }
  let!(:orders) { create_list(:order, 20, shop_id: shop.id) }
  let(:shop_id) { shop.id }
  let(:id) { orders.first.id }

  # Test suite for GET /api/v1/shops/:shop_id/orders
  describe 'GET /api/v1/shops/:shop_id/orders' do
    before { get api_v1_shop_orders_path(shop_id: shop_id) }

    context 'when shop exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all orders' do
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

  # Test suite for GET /api/v1/shops/:shop_id/orders/:id
  describe 'GET /api/v1/shops/:shop_id/orders/:id' do
    before { get "/api/v1/shops/#{shop_id}/orders/#{id}" }

    context 'when product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when order does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Order/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/orders
  describe 'POST /api/v1/shops/:shop_id/orders' do
    let(:valid_attributes) { { order: { date: Faker::Date.between(2.days.ago, Date.today), shop_id: shop_id } } }

    context 'when request attributes are valid' do
      before { post api_v1_shop_orders_path(shop_id: shop_id), params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post api_v1_shop_orders_path(shop_id: shop_id), params: { order: { wrong: 'idk'} } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/{\"shop\":\[\"must exist\"\],\"date\":\[\"can't be blank\"\]}/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:shop_id/orders/:id
  describe 'PUT /api/v1/shops/:shop_id/orders/:id' do
    let(:date) { Faker::Date.between(2.days.ago, Date.today) }
    let(:valid_attributes) { { order: { date: date } } }

    before { put "/api/v1/shops/#{shop_id}/orders/#{id}", params: valid_attributes }

    context 'when order exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the order' do
        updated_order = Order.find(id)
        expect(updated_order.date).to match(date)
      end
    end

    context 'when the product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Order/)
      end
    end
  end

  # Test suite for DELETE /api/v1/shops/:id
  describe 'DELETE /api/v1/shops/:id' do
    before { delete "/api/v1/shops/#{shop_id}/orders/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
