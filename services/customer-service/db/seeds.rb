User.create!(email: 'admin@example.com', password: 'password123')
3.times do
  Customer.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    billing_address: Faker::Address.full_address
  )
end
