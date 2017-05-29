# The LTV Module is responsible for calculating LTV for a set of orders, it will produce average LTV across different time periods and cohorts

module LTV
  extend self
  
  def data(orders=Order.all)
    data = {avgs:{}, summ:{avgs_by_month:{}, sums_by_cohort:{} }}
    cohorts = get_cohorts(orders)
    months = get_month(orders)
    cohorts.each do |cohort|
      months.each do |month|
        data[:avgs][cohort] = avg(cohort,month,orders)
      end
    end
    data
    
  end
  
  def get_cohorts(orders)
    cohorts = Customer.joins(:orders).merge(orders).pluck(:cohort).uniq
    cohorts.min.upto(cohorts.max).map {|x| x}
  end
  
  def get_month(orders)
    months = orders.pluck(:month).uniq
    months.min.upto(months.max).map {|x| x}
  end
  
  def sum(cohort,month,orders=Order.all)
    orders = Order.all_cohort_month(cohort,month,orders)
    orders.map { |order| order.total }.sum
  end
  
  def avg(cohort,month,orders=Order.all)
    if occured?(cohort,month)
      cohort_members = Customer.joins(:orders).merge(orders).where(cohort:cohort).size
      (sum(cohort,month,orders) / cohort_members).round(2)
    else
      nil
    end
  end
  
  def avg_rev_by_month(cohorts,month)
    avgs = []
    cohorts.each do |cohort|
      avgs << avg(cohort,month)
    end
    avgs.compact!
    (avgs.sum / avgs.size).round(2)
  end
  
  def sum_rev_by_month(cohort,months)
    sums = []
    months.each do |month|
      sums << avg(cohort,month)
    end
    sums.compact!
    (sums.sum).round(2)
  end
  
  def avg_data(cohorts=Customer.all_cohorts,months=Customer.all_months)
    data = {}
    months.each do |month|
      data[month] = avg_rev_by_month(cohorts,month)
    end
    data
  end
  
  def sum_data_by_cohort(cohorts=Customer.all_cohorts,months=Customer.all_months)
    data = {}
    cohorts.each do |cohort|
      data[cohort] = sum_rev_by_month(cohort,months)
    end
    data
  end
  
  def sum_cum_rev(data,month)
    (1.upto(month).map { |month| data[month]}.sum).round(2)
  end
  
  def calc_time(cohort,month)
    cohort_start_date = $start_date + ((cohort-1).months)
    cohort_start_date + ((month-1).months)
  end
  
  def stringify_date(date)
    date.strftime('%b-%y')
  end
  
  def occured?(cohort,month)
    calc_time(cohort,month) < $end_date
  end
  
  def last_month(cohort)
    cohort_start_date = $start_date + ((cohort-1).months)
    DateCalc.month_diff(cohort_start_date,$end_date) + 1
  end
  
  def json
    raw_data = avg_data
    data = {}
    data['x_data'] = raw_data.keys
    data['y_data'] = raw_data.values
    p data.to_json
  end
end