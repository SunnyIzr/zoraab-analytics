class Customer < ActiveRecord::Base
  has_many :orders
  validates_uniqueness_of :email
  validates_presence_of :email

  def join_date
    self.orders.sort_by { |o| o.created_at }.first.created_at
  end
 
  def set_cohort
    self.cohort = DateCalc.month_diff($start_date,self.join_date) + 1
    self.save
  end

  def self.cohort_month(cohort)
    new_date = $start_date + (cohort.months)
    new_date -= 1.month
    new_date.strftime('%b-%y')
  end
 
  def self.all_cohorts(start_date=$start_date,end_date=$end_date)
    start_pos = DateCalc.month_diff($start_date,start_date) + 1
    end_pos = DateCalc.month_diff(start_date,end_date) + 1  
    [*start_pos..end_pos]
  end
  
  def self.all_months(start_date=$start_date)
    end_pos = DateCalc.month_diff(start_date,$end_date) + 1  
    [*1..end_pos]
  end

end
