require 'dynamic_reports'

class SampleController < ApplicationController

  def visitors_report
    a = Analytics.all(:limit => 20)

    render :inline => AllVisitorsReport.on(a).to_html
  end

  def sales_report
    sales = Sales.find(:all, :conditions => "Territory <> 'Canada'")

    render :inline => SalesReport.on(sales).to_html
  end
end
