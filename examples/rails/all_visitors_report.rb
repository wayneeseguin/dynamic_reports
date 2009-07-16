# Sample Report Definition
#
# Must be located at APP/REPORTS/ALL_VISITOR_REPORT.RB
#
class AllVisitorsReport < DynamicReports::Report
  title "All Visitors"
  columns :recorded_at, :visits, :pageviews

  chart :visits do
    title "visits"
    type "line"
    columns :visits
    label_column :recorded_at
  end

  chart :visits_and_pageviews, {:chdlp=>"b"} do
    title "Visits and Pageviews END"
    type "column"
    width "300"
    height "600"
    columns :visits, :pageviews
    label_column :recorded_at
  end

  chart :visits_and_pageviews, {:chdlp=>"b"} do
    title "Visits and Pageviews END"
    type "bar"
    width "600"
    height "300"
    columns :visits, :pageviews
    label_column :recorded_at
  end


  chart :pie do
    title "Visits"
    type "pie"
    label_column :recorded_at
    columns :visits
    width "500"
  end

end
