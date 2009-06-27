class ReportsTest < Test::Unit::TestCase
  context "Views" do

    setup do
      class ViewTestReport < DynamicReports::Report
        name  "Report for testing views."
        title "Test la views!"
        columns :recorded_at, :viewed_on, :pageviews_count, :visits_count, :conversions_count
        template :specific_template
        views "#{File::dirname(File::expand_path(__FILE__))}/views/"
      end
      @array_records  = DynamicReports::Test::ArrayRecords.generate(ViewTestReport, :count => 10)
      @report = ViewTestReport.on(@array_records)
      @view = DynamicReports::View.new(@report)
    end

    should "have the same views path as the report object it is called with" do
      assert_equal @report.views, @view.views
    end

    should "render a specific_template when specified" do
      assert_equal "This is the specified template!",
        @view.__send__("#{:erb}", ViewTestReport.options).strip
    end

  end
end
