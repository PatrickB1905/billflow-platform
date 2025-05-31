Rswag::Ui.configure do |c|
  # Mount the spec you generated at /api-docs/v1/swagger.yaml
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'Subscription Service API V1'
end
