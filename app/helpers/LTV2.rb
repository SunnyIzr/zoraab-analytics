module LTV2
  extend self
  
  def data(orders)
    {
      avgs: avg_data(orders),
      avg_by_month: avg_by_month_data(orders),
      sum_by_cohort: sum_by_cohort_data(orders),
    }
  end
  
  def ltv(data)
    last_month = data[:avg_by_month].keys.last
    (0.5*(sum_cum_by_month(data,last_month))).round(2)
  end
  
  def avg_data(orders)
    avg_data = {}
    cohorts(orders).each do |cohort|
      avg_data[cohort] = {}
      months(orders).each do |month|
        avg_data[cohort][month] = avg(cohort,month,orders)
      end
    end
    avg_data
  end
  
  def avg_by_month_data(orders)
    data = {}
    months(orders).each do |month|
      data[month] = avg_by_month(month,orders)
    end
    data
  end
  
  def sum_by_cohort_data(orders)
    data = {}
    cohorts(orders).each do |cohort|
      data[cohort] = sum_by_cohort(cohort,orders)
    end
    data
  end
  
  def sum_cum_by_month(data,month)
    (1.upto(month).map { |month| data[:avg_by_month][month]}.compact.sum).round(2)
  end
  
  def avg_by_month(month,orders)
    avgs = []
    cohorts(orders).each do |cohort|
      avgs << avg(cohort,month,orders)
    end
    avgs.compact!
    (avgs.sum / avgs.size).round(2)
  end
  
  def sum_by_cohort(cohort,orders)
    sums = []
    months(orders).each do |month|
      sums << avg(cohort,month,orders)
    end
    sums.compact!
    (sums.sum).round(2)
  end
  
  def customers(orders)
    Customer.joins(:orders).merge(orders).uniq
  end
  
  def cohorts(orders)
    Customer.all_cohorts
  end
  
  def months(orders)
    Customer.all_months
  end
  
  def orders_by_cohort_month(cohort,month,orders)
    orders.where(month:month).joins(:customer).merge(Customer.where(cohort:cohort))
  end
  
  def sum(cohort,month,orders)
    orders = orders_by_cohort_month(cohort,month,orders)
    orders.map { |order| order.total }.sum
  end
  
  def avg(cohort,month,orders)
    if occured?(cohort,month)
      cohort_members = customers(orders).where(cohort: cohort).size
      (sum(cohort,month,orders) / cohort_members).round(2)
    else
      nil
    end
  end
  
  def occured?(cohort,month)
    calc_time(cohort,month) < $end_date
  end
  
  def calc_time(cohort,month)
    cohort_start_date = $start_date + ((cohort-1).months)
    cohort_start_date + ((month-1).months)
  end
  
  def stringify_date(date)
    date.strftime('%b-%y')
  end
  
  def last_month(cohort)
    cohort_start_date = $start_date + ((cohort-1).months)
    DateCalc.month_diff(cohort_start_date,$end_date) + 1
  end
  
end