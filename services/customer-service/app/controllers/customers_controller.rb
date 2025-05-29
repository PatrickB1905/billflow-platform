# services/customer-service/app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  # GET /customers
  def index
    customers = Customer.all
    render json: customers, status: :ok
  end

  # GET /customers/:id
  def show
    customer = Customer.find(params[:id])
    render json: customer, status: :ok
  end

  # POST /customers
  def create
    customer = Customer.create!(customer_params)
    render json: customer, status: :created
  end

  # PUT/PATCH /customers/:id
  def update
    customer = Customer.find(params[:id])
    customer.update!(customer_params)
    render json: customer, status: :ok
  end

  # DELETE /customers/:id
  def destroy
    Customer.find(params[:id]).destroy
    head :no_content
  end

  private

  def customer_params
    # only allow the three attributes
    params.permit(:name, :email, :billing_address)
  end
end
