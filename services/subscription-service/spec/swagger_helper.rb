require 'rails_helper'

RSpec.configure do |config|
  # where the generated YAML will be written to
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'BillFlow Subscription API',
        version: 'v1',
        description: 'API documentation for Subscription Service'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3002',
          variables: {
            defaultHost: {
              default: 'localhost:3002'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        }
      },
      security: [{ bearerAuth: [] }]
    }
  }

  config.swagger_format = :yaml
end
