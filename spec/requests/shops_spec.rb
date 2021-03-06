require 'rails_helper'

RSpec.describe 'Shops API', type: :request do
  # Initialize the test data
  # add shop owner
  let(:user) { create(:user) }
  let!(:test_shop) { create(:shop, created_by: user.id) }
  let(:shop_id) { test_shop.id }

  # authorize request
  let(:headers) { valid_headers }

  describe 'GET api/v1/shops' do
    # make HTTP get request before each example
    before { get api_v1_shops_path, params: {}, headers: headers }

    it 'returns shops' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /shops/:id
  describe 'GET api/v1/shops/:id' do
    before { get "/api/v1/shops/#{shop_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the shop' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(shop_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:shop_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Shop/)
      end
    end
  end

  # Test suite for POST /api/v1/shops
  describe 'POST /api/v1/shops' do
    # valid payload
    let(:valid_attributes) { { shop: { name: 'Learn Elm Shop', created_by: user.id.to_s } }.to_json }

    context 'when the request is valid' do
      before { post api_v1_shops_path, params: valid_attributes, headers: headers }

      it 'creates a shop' do
        expect(json['name']).to eq('Learn Elm Shop')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post api_v1_shops_path, params: { shop: {name: nil } }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name'].to_s)
          .to match(/can't be blank/)
      end
    end
  end

  # Test suite for PUT /api/v1/shops/:id
  describe 'PUT api/v1/shops/:id' do
    let(:valid_attributes) { { shop: { name: 'Shopping Store' } }.to_json }

    context 'when the record exists' do
      before { put "/api/v1/shops/#{shop_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json['name']).to eq('Shopping Store')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /api/v1/shops/:id
  describe 'DELETE api/v1/shops/:id' do
    before { delete "/api/v1/shops/#{shop_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
