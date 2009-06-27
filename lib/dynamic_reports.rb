# :include: README

# Library Files
module DynamicReports
  @@default_view_paths = ["#{File::dirname(File::expand_path(__FILE__))}/dynamic_reports/views/"]
  def self.default_view_paths
    @@default_view_paths
  end
  def self.default_view_paths=(paths)
    @@default_view_paths = paths
  end
end

require "dynamic_reports/charts"
require "dynamic_reports/reports"
require "dynamic_reports/templates"
require "dynamic_reports/views"
require "dynamic_reports/vendor/google_chart"


# TODO: Figure out why this will not load:
# require "dynamic_reports/rails"
# For now placing the code right here:
if defined?(Rails)
  # Load all defined reports. 
  # Question: How to get Rails to reload files other than ones matching the requested constant...
  #Dir.glob("#{File.join(Rails.root, "app", "reports")}/*.rb").each { |file| require file }
  ActiveSupport::Dependencies.load_paths << File.join(Rails.root, "app", "reports")
  # Question: Should we allow for report directory nesting ?

  # Set default views directory
  # TODO: These should be added to Rails views directories?
  DynamicReports.default_view_paths += [
    File.join(Rails.root, "app", "views", "reports"),
    File.join(Rails.root, "app", "views", "layouts")
  ]

  # TODO: Render extension

  # TODO: AR extensions:
  #       has_report :daily, :columns => [...], :options => {...}, :title => ...
  #         Which will generate a report object DailyReport with the given definition.
  #         Everything after the name corresponds to options available in the configuration block.

  # TODO: Generator
end

