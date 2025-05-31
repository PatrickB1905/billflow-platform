class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :restrict_with_error

  INTERVALS = %w[monthly yearly].freeze

  validates :name,        presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :interval,    presence: true, inclusion: { in: INTERVALS }
end
