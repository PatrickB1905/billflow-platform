class Subscription < ApplicationRecord
  belongs_to :plan

  STATUSES = %w[pending active cancelled].freeze

  validates :customer_id, :plan_id, :status, :start_date, presence: true
  validates :status, inclusion: { in: STATUSES }

  # Calculate next billing on monthly/yearly cycle
  def next_billing_date
    base = last_billed_at || start_date
    plan.interval == 'monthly' ? base.next_month : base.next_year
  end
end
