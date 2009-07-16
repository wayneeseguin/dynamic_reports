# Sample Report Definition
#
# must be located at APP/REPORTS/SALES_REPORT.RB
#
class SalesReport < DynamicReports::Report
  title "Sales By Territory"
  columns :territory, :total_sales, :net_profit, :gross_profit
  class_name "sales_div"

  chart :pie do
    title "Territory Breakdown"
    type "pie"
    label_column :territory
    columns :net_profit
    width "500"
  end

end
