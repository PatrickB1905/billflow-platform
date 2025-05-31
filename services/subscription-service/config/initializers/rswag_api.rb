Rswag::Api.configure do |c|
  # Tell swagger-api where the generated JSON/YAML lives
  c.swagger_root = Rails.root.join('swagger').to_s
end
