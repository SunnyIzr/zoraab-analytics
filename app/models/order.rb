class Order < ActiveRecord::Base
  belongs_to :customer
  validates_uniqueness_of :number
  validates_presence_of :number
  
  def month_since_join
    DateCalc.month_diff(self.customer.join_date, created_at) + 1
  end
  
  def self.shopify(order)
    new_order = self.new(created_at: order[:created_at], number: order[:number], total: order[:total])
    new_order.customer = Customer.find_or_create_by(email: order[:email], name: order[:billing_address][:name])
    new_order.save
  end
  
  def self.get_orders(start_date,end_date)
    Order.where("created_at >= :start_date AND created_at <= :end_date", {:start_date => start_date, :end_date => end_date})
  end
  
  def self.avg_total(start_date , end_date)
    orders = get_orders(start_date,end_date)
    calc_avg(orders)
  end
  
  def self.calc_avg(orders)
    totals = orders.map { |order| order.total }
    (totals.sum / orders.size).round(2)
  end
  
  def self.all_totals(orders)
    orders.map { |o| o.total }.sort
  end
  
  def self.all_cohort(cohort,orders=Order.all)
    # Returns all the orders that belong to a customer with the specified cohort
    orders.joins(:customer).merge(Customer.where(cohort:cohort))
  end
  
  def self.all_cohort_month(cohort,month,orders=Order.all)
    all_cohort(cohort,orders).where(month: month)
  end

  def self.sum_cohort_month(cohort,month)
    orders = get_orders_by_cohort_and_month(cohort,month)
    totals = orders.map { |order| order.total }
    (totals.sum / Customer.where(cohort:cohort).size ).round(2)
  end

end
