User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password123'
end

Plan.find_or_create_by!(name: 'Basic') do |p|
  p.price_cents = 1000
  p.interval    = 'monthly'
end

Plan.find_or_create_by!(name: 'Pro') do |p|
  p.price_cents = 2500
  p.interval    = 'monthly'
end

Plan.find_or_create_by!(name: 'Enterprise') do |p|
  p.price_cents = 50000
  p.interval    = 'yearly'
end
