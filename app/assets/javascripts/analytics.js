var AnalyticsController = {
  init: function() {
    this.refreshAvg()
    
  },
  refreshAvg: function() {
    $('#date-range').click(function() {
      AnalyticsModel.calcAvg()
    })
  }  
}

var AnalyticsModel = {
  startDate: function() {
    return $('#start_date').val()
  },
  endDate: function() {
    return $('#end_date').val()
  },
  calcAvg: function() {
    $.post('/avg-total/', 
      {start_date: this.startDate, end_date: this.endDate}, 
      function(data) { 
        AnalyticsView.updateAvgOrder(data)
    })
  }
}

var AnalyticsView = {
  updateAvgOrder: function(avg) {
    $('#avg-order').html(avg)
  }
  
}
