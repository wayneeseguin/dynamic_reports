# $ script/generate report all_visitors title:"Daily Usage Report" chart_type:svg columns:all charts:pageviews,daily_visitors
# Note the type: part of the generator simply fills in the shell and you must enter the rest.

# app/reports/daily_report.rb
# Report with two accompanying charts.
class DailyReport < DynamicReports::Report
  # Default title is extracted from name, example "Daily Report"
  title "Daily Usage Report"

  # sub_title # optional
  columns :all # or an array of columns.

  chart :pageviews, :type => :svg do
    title "Pageviews Over Time"
    sub_title "this is optional"
    type "line" # Perhaps this is default for multiple columns.
    size "350x250"
    columns :created_at, :pageviews
    # x_axis "x-axis label" # Defaults to "Created At"
    # y_axis "y-axis label" # defaults to "Pageviews"
  end
  
  chart :daily_visitors, :type => :google do
    title = "Daily Visitors"
    type = "bar" # perhaps this is default for single column.
    size = "350x250"
    # x_axis "x-axis label"
    # y_axis "y-axis label"
    columns :visitors
    # label
    # caption
    # alignment
  end
  
  # SUB REPORTS LINKAGE
  # HTML only.
  link_column :visitors do |column_link|
    # Hover title text
    column_link.title "Show all visitors from this date."
    
    # Click on the visitors cell, which is hyperlinked, 
    # and it passes the value in the same row of column 
    # created_at as a param called sdate to a defined action"
    column_link.column :created_at, :as => "start_date"
    # adds :sdate => :created_at to @parameters hash.
  
    # Perhaps allow for simple passing as well:
    column_link.columns :some_more, :column_names
  
    # ... this is slightly tricky, 
    # need a way to configure base reporting url
    # and perhaps default to "/reports/:report_name"
    column_link.url = url(:action => "show_all_visitors") 
  end
  
  # HTML only.
  link_rows do ||
    # Perhaps add the ability to link rows to reports also?
  end

end


# $ script/generate report all_visitors title:"All Visitors On :start_date" columns:name,ip_address
class AllVisitorsReport < DynamicReports::Report
  title "All Visitors On :start_date"
  columns :name, :ip_address
end


# $ script/generate report pageviews_vs_revinue columns:pageviews,revinue,visits
class PageviewsVsRevinueReport < DynamicReports::Report
    # No title specifed so defaults to:
    # title "Pageviews Vs Revinue"
    columns :pageviews, :revenue, :visits
  end
end

#
# Using the defined reports
#

# app/controllers/some_models_controller.rb
class SomeModelsController < ApplicationController
 
  def daily_report
    @data = SomeModel.report(...)
    # render :report will assume a template is available in
    #   app/reports/:report_name.format.extension 
    # In addition that app/views/reports.format.layout is available
    #   unless :layout => false is passed.
    render :report => :daily_report, :on => @records, :format => :html
    #OR
    #render DailyReport.on(@records).html
  end

  def pageviews_vs_revinue
    @report = PageviewsVsRevinueReport # This could also be set in a before_filter :)
    @records = SomeModel.find(...)
    respond_to do |format|
      format.html do
        render :report => PageviewsVsRevinueReport, :on => @records #, :format => :html # default
      end
      format.xml do
        render :report => PageviewsVsRevinueReport, :on => @records, :format => :nokogiri
      end
      format.csv do
        render :report => PageviewsVsRevinueReport, :on => @records, :format => :csv # fastercsv
      end
      format.pdf do
        render :report => PageviewsVsRevinueReport, :on => @records, :format => :pdf # prawn
      end
  end

  def all_visitors
    # DefaultReport simply reports on all columns for the give record set.
    # If it is a hash it simply iterates over the keys
    # If it responds to #attributes method it will iterate over those.
    # "give me all the columns for this model" perhaps?
    @records = VisitorsModel.find(:conditions => ["created_at > ?", params[:start_date])

    render :report => :default, :on => @records #, :format => :html # default
  end

  def two_reports
    @records = SomeModel.find(...)
    # Render multiple reports as one?
    render :reports => [:daily_report,PageviewsVsRevinueReport], :on => @records #, :format => :html # default
    # OR
    # render (DailyReport.on(@records).to_html + PageviewsVsRevinueReport.on(@record).to_html)
  end
end
