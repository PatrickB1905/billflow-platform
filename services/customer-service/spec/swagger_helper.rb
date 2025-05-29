# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger YAML files are generated
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'BillFlow Customer API',
        version: 'v1',
        description: 'API documentation for Customer Service'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3001',
          variables: {
            defaultHost: {
              default: 'localhost:3001'
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

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'
  config.swagger_format = :yaml
end
