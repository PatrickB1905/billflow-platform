require 'swagger_helper'

RSpec.describe 'Customers API', type: :request do
  # Create a test user so JWT can find it
  let!(:user) { User.create!(email: 'admin@example.com', password: 'password123') }

  let!(:customer1) { Customer.create!(name: 'Test One', email: 'one@test.com', billing_address: '123 Lane') }
  let!(:customer2) { Customer.create!(name: 'Test Two', email: 'two@test.com', billing_address: '456 Road') }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

  path '/customers' do
    get 'List Customers' do
      tags 'Customers'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'
      produces 'application/json'

      response '200', 'customers listed' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id:              { type: :integer },
                   name:            { type: :string },
                   email:           { type: :string },
                   billing_address: { type: :string }
                 }
               }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid.token.here' }
        run_test!
      end
    end

    post 'Create Customer' do
      tags 'Customers'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'
      consumes 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name:            { type: :string },
          email:           { type: :string },
          billing_address: { type: :string }
        },
        required: %w[name email billing_address]
      }

      response '201', 'customer created' do
        let(:customer) { { name: 'New', email: 'new@test.com', billing_address: '789 Blvd' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:customer) { { name: '' } }
        run_test!
      end
    end
  end

  path '/customers/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Customer ID'

    get 'Retrieve a Customer' do
      tags 'Customers'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'
      produces 'application/json'

      response '200', 'customer found' do
        let(:id) { customer1.id }
        run_test!
      end

      response '404', 'customer not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a Customer' do
      tags 'Customers'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'
      consumes 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '200', 'customer updated' do
        let(:id)       { customer1.id }
        let(:customer) { { name: 'Updated Name' } }
        run_test!
      end
    end

    delete 'Delete a Customer' do
      tags 'Customers'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'

      response '204', 'customer deleted' do
        let(:id) { customer2.id }
        run_test!
      end
    end
  end
end
