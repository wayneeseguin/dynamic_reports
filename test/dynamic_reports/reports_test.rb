class ReportsTest < Test::Unit::TestCase
  context "a report" do

    setup do
      class TheReport < DynamicReports::Report
        name  "The Report!"
        title "Daily Report"
        sub_title "Happens every day, ya!"
        columns :recorded_at, :viewed_on, :pageviews_count, :visits_count, :conversions_count

        chart :visits do
          title "testing chart"
          columns :visits
          type "line"
        end
      end
      @array_records  = DynamicReports::Test::ArrayRecords.generate(TheReport, :count => 10)
      @object_records = DynamicReports::Test::ObjectRecords.generate(TheReport, :count => 10)
    end

    teardown do
    end

    should "allow setting the title of a report" do
      assert_equal "Daily Report", TheReport.title
    end

    should "allow setting the sub title of a report" do
      assert_equal "Happens every day, ya!", TheReport.sub_title
    end
    
    #should "allow setting the report template base (not type/extension)" do
    #  assert_equal TheReport.template, "my_special_template"
    #end
    
    should "allow setting the columns to report on" do
      assert_equal [:recorded_at, :viewed_on, :pageviews_count, :visits_count, :conversions_count], TheReport.columns
    end

    should "return an instantiated report .on is called" do
      assert_kind_of DynamicReports::Report, 
        TheReport.on(@array_records)
    end

    should "An instantiated report should return html table report when to_html is called" do
      assert_match(/<table class="report"/, TheReport.on(@array_records).to_html)
    end

    should "An instantiated report should contain the rendered chart that was defined" do
      assert_match(/class="report_charts"/, TheReport.on(@array_records).to_html)
    end
    
    context "Report with template specified" do
      setup do
        class SpecificTemplateReport < DynamicReports::Report
          name  "A report with specified template!"
          title "Specify Template Report"
          sub_title "template is 'other_template'"
          columns :recorded_at, :viewed_on, :pageviews_count, :visits_count, :conversions_count
          template :specific_template
          views "#{File::dirname(File::expand_path(__FILE__))}/views/"
        end
        @array_records  = DynamicReports::Test::ArrayRecords.generate(SpecificTemplateReport, :count => 10)
        @object_records = DynamicReports::Test::ObjectRecords.generate(SpecificTemplateReport, :count => 10)
      end

      teardown do
      end

      should "allow setting of the views directories" do
        assert_contains SpecificTemplateReport.views, 
          "#{File::dirname(File::expand_path(__FILE__))}/views/"
      end

      should "the instance should have the same views as the class" do
        assert_contains SpecificTemplateReport.on(@array_records).views, 
          "#{File::dirname(File::expand_path(__FILE__))}/views/"
      end

      should "render with the specified template, from the specified views directory" do
        assert_equal "This is the specified template!", 
          SpecificTemplateReport.on(@array_records).to_html.strip
      end
    end
  end

end
