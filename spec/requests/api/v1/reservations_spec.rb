require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  before do
    @user, @user1 = User.create([
                                  {
                                    username: 'Yashodhi',
                                    email: 'yash@email.com',
                                    password: 'abcdef',
                                    password_confirmation: 'abcdef'
                                  },
                                  {
                                    username: 'Nouridine',
                                    email: 'nour@email.com',
                                    password: 'abcdef',
                                    password_confirmation: 'abcdef'
                                  }
                                ])
    @house = @user.houses.create(name: 'House1', description: 'beautiful house', area: 100, number_of_rooms: 3,
                                 location: 'Niger', price: 25)
    @reservation = @house.reservations.create(
      user: @user1,
      booking_date: '2023-09-26T14:41:07.381Z',
      checkout_date: '2024-09-26T14:41:07.381Z',
      total_charge: 40
    )

    @auth_headers = @user1.create_new_auth_token if @user
  end

  path '/api/v1/houses/{house_id}/reservations' do
    # You'll want to customize the parameter types...
    parameter name: 'house_id', in: :path, type: :string, description: 'house_id'
    parameter name: 'access-token', in: :header, type: :string, required: true
    parameter name: 'client', in: :header, type: :string, required: true
    parameter name: 'uid', in: :header, type: :string, required: true

    get('list reservations') do
      response(200, 'successful') do
        let(:house_id) { @house.id }
        let(:'access-token') { @auth_headers['access-token'] }
        let(:client) { @auth_headers['client'] }
        let(:uid) { @auth_headers['uid'] }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response(401, 'Unauthorized (Not providing correct header)') do
        let(:house_id) { @house.id }
        let(:'access-token') { 'access-token' }
        let(:client) { 'client' }
        let(:uid) { 'uid' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create reservation') do
      produces 'application/json'
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          booking_date: { type: :string },
          checkout_date: { type: :number }
        }
      }

      response(201, 'reservation created successful') do
        let(:'access-token') { @auth_headers['access-token'] }
        let(:client) { @auth_headers['client'] }
        let(:uid) { @auth_headers['uid'] }
        let(:house_id) { @house.id }
        let(:reservation) do
          {
            booking_date: '2023-09-26T14:41:07.381Z',
            checkout_date: '2024-09-26T14:41:07.381Z'
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'You should provide required parameters)') do
        let(:'access-token') { 'access-token' }
        let(:client) { 'client' }
        let(:uid) { 'uid' }
        let(:house_id) { @house.id }
        let(:reservation) do
          {
            booking_date: '2023-09-26T14:41:07.381Z',
            checkout_date: '2024-09-26T14:41:07.381Z'
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/houses/{house_id}/reservations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'house_id', in: :path, type: :string, description: 'house_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'
    parameter name: 'access-token', in: :header, type: :string, required: true
    parameter name: 'client', in: :header, type: :string, required: true
    parameter name: 'uid', in: :header, type: :string, required: true

    delete('delete reservation') do
      response(201, 'successful') do
        let(:'access-token') { @auth_headers['access-token'] }
        let(:client) { @auth_headers['client'] }
        let(:uid) { @auth_headers['uid'] }
        let(:house_id) { @house.id }
        let(:id) { @reservation.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
