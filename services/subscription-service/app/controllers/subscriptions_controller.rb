class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update destroy dry_run]

  def index   = render json: Subscription.all
  def show    = render json: @subscription
  def create
    sub = Subscription.create!(
      subscription_params.merge(start_date: Date.today, status: 'pending')
    )
    render json: sub, status: :created
  end
  def update = @subscription.update!(subscription_params) && render(json: @subscription)
  def destroy = @subscription.destroy && head(:no_content)

  # GET /subscriptions/:id/dry_run
  def dry_run
    render json: {
      next_billing_date: @subscription.next_billing_date,
      amount_cents:      @subscription.plan.price_cents
    }
  end

  private

  def set_subscription = @subscription = Subscription.find(params[:id])
  def subscription_params = params.permit(:customer_id, :plan_id, :status)
end
