class OrdersController < ApplicationController
  def query
  end
  def average_order
    start_date = params[:start_date]
    end_date = params[:end_date]
    orders = Order.where("created_at >= :start_date AND created_at <= :end_date", {:start_date => start_date, :end_date => end_date})
    totals = orders.map { |order| order.total }
    totals.sum / orders.size
  end
end
