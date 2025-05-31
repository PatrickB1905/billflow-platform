require 'swagger_helper'

describe 'Authentication API' do
  path '/auth/login' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email:    { type: :string, example: 'admin@example.com' },
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
        let(:credentials) { { email: 'wrong@example.com', password: 'nope' } }
        run_test!
      end
    end
  end
end
