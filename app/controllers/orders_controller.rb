class OrdersController < ApplicationController
  def query
    trans_type = params[:trans_type]
    @orders = trans_type.nil? ? Order.all : Order.where(trans_type: trans_type)
    @cohorts = Customer.all_cohorts
    @months = Customer.all_months
    @data = LTV2.data(@orders)
  end
  def avg_total
    start_date = params[:start_date]
    end_date = params[:end_date]
    render json: Order.avg_total(Time.parse(start_date),Time.parse(end_date))
  end
  def all_totals
    start_date = params[:start_date]
    end_date = params[:end_date]
    orders = Order.get_orders(Time.parse(start_date),Time.parse(end_date))
    render json: Order.all_totals(orders)
  end
  def ltv_chart
    render json: LTV.json
  end
end
