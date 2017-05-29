module DateCalc
  extend self
  
  def month_diff(date1,date2)
    (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
  end
end