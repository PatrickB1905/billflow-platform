require 'swagger_helper'

describe 'Subscriptions API' do
  let!(:user)          { User.create!(email: 'admin@example.com', password: 'password123') }
  let!(:plan)          { Plan.create!(name: 'Basic', price_cents: 1000, interval: 'monthly') }
  let!(:subscription)  { Subscription.create!(customer_id: 1, plan_id: plan.id, status: 'pending', start_date: Date.today) }
  let(:Authorization)  { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

  path '/subscriptions' do
    get 'List subscriptions' do
      tags 'Subscriptions'
      security [ bearerAuth: [] ]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'subscriptions listed' do
        run_test!
      end
    end

    post 'Create a subscription' do
      tags 'Subscriptions'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :subscription, in: :body, schema: {
        type: :object,
        properties: {
          customer_id: { type: :integer },
          plan_id:     { type: :integer }
        },
        required: %w[customer_id plan_id]
      }

      response '201', 'subscription created' do
        let(:subscription) { { customer_id: 1, plan_id: plan.id } }
        run_test!
      end

      response '422', 'invalid' do
        let(:subscription) { { customer_id: nil } }
        run_test!
      end
    end
  end

  path '/subscriptions/{id}/dry_run' do
    parameter name: :Authorization, in: :header, type: :string
    parameter name: :id, in: :path, type: :integer

    get 'Dry-run billing' do
      tags 'Subscriptions'
      security [ bearerAuth: [] ]

      response '200', 'dry-run returned' do
        let(:id) { subscription.id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
