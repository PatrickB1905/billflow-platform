require 'swagger_helper'

describe 'Plans API' do
  let!(:user)  { User.create!(email: 'admin@example.com', password: 'password123') }
  let!(:plan)  { Plan.create!(name: 'Test Plan', price_cents: 1234, interval: 'monthly') }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

  path '/plans' do
    get 'List all plans' do
      tags 'Plans'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer JWT'

      response '200', 'plans listed' do
        run_test!
      end
    end

    post 'Create a plan' do
      tags 'Plans'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string
      consumes 'application/json'
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
          name:        { type: :string },
          price_cents: { type: :integer },
          interval:    { type: :string, enum: %w[monthly yearly] }
        },
        required: %w[name price_cents interval]
      }

      response '201', 'plan created' do
        let(:plan) { { name: 'Gold', price_cents: 5000, interval: 'yearly' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:plan) { { name: '' } }
        run_test!
      end
    end
  end

  path '/plans/{id}' do
    parameter name: :Authorization, in: :header, type: :string
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a plan' do
      tags 'Plans'
      security [ bearerAuth: [] ]

      response '200', 'plan found' do
        let(:id) { plan.id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a plan' do
      tags 'Plans'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: { name: { type: :string } }
      }

      response '200', 'plan updated' do
        let(:id)   { plan.id }
        let(:plan) { { name: 'Silver' } }
        run_test!
      end
    end

    delete 'Delete a plan' do
      tags 'Plans'
      security [ bearerAuth: [] ]

      response '204', 'plan deleted' do
        let(:id) { plan.id }
        run_test!
      end
    end
  end
end
