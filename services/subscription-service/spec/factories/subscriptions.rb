FactoryBot.define do
  factory :subscription do
    customer_id { 1 }
    plan { nil }
    status { "MyString" }
    start_date { "2025-05-29" }
    last_billed_at { "2025-05-29" }
  end
end
