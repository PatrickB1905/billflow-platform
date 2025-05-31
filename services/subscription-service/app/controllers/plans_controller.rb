class PlansController < ApplicationController
  def index   = render json: Plan.all
  def show    = render json: Plan.find(params[:id])
  def create  = render json: Plan.create!(plan_params), status: :created
  def update
    plan = Plan.find(params[:id])
    plan.update!(plan_params)
    render json: plan
  end
  def destroy = Plan.find(params[:id]).destroy && head(:no_content)

  private
  def plan_params = params.permit(:name, :price_cents, :interval)
end
