class Customer < ApplicationRecord
  validates :name, :email, :billing_address, presence: true
end
