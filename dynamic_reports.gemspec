# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dynamic_reports}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wayne E. Seguin", "Joshua Lippiner"]
  s.date = %q{2009-07-01}
  s.description = %q{Dynamic Ruby Reporting Engine with support for Charts.}
  s.email = %q{wayneeseguin@gmail.com, jlippiner@gmail.com}
  s.extra_rdoc_files = [
    "README",
     "README.rdoc"
  ]
  s.files = [
    "HISTORY",
     "README",
     "dynamic_reports.gemspec",
     "lib/dynamic_reports.rb",
     "lib/dynamic_reports/charts.rb",
     "lib/dynamic_reports/reports.rb",
     "lib/dynamic_reports/templates.rb",
     "lib/dynamic_reports/vendor/google_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/bar_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/base.rb",
     "lib/dynamic_reports/vendor/google_chart/financial_line_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/line_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/pie_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/scatter_chart.rb",
     "lib/dynamic_reports/vendor/google_chart/venn_diagram.rb",
     "lib/dynamic_reports/views.rb",
     "lib/dynamic_reports/views/default_layout.html.erb",
     "lib/dynamic_reports/views/default_report.html.erb",
     "lib/dynamic_reports/views/default_report.html.haml"
  ]
  s.homepage = %q{http://dynamicreports.rubyforge.org/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dynamicreports}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Dynamic Ruby Reporting Engine with support for Charts}
  s.test_files = [
    "test/dynamic_reports/charts_test.rb",
     "test/dynamic_reports/reports_test.rb",
     "test/dynamic_reports/templates_test.rb",
     "test/dynamic_reports/views_test.rb",
     "test/dynamic_reports.rb",
     "test/factories/records.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
