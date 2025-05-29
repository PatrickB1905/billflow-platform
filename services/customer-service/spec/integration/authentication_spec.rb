require 'swagger_helper'

describe 'Authentication API' do
  let!(:user) { User.create!(email: 'admin@example.com', password: 'password123') }
  
  path '/auth/login' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'
      security []
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'admin@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response '200', 'login successful' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 exp:   { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id:    { type: :integer },
                     email: { type: :string }
                   }
                 }
               },
               required: %w[token exp user]

        let(:credentials) { { email: 'admin@example.com', password: 'password123' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'wrong', password: 'wrong' } }
        run_test!
      end
    end
  end
end
