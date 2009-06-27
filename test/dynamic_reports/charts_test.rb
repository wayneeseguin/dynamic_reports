class ChartsTest < Test::Unit::TestCase
  context "charts" do
    setup do
      class TheReport < DynamicReports::Report
        chart :the_chart_name, :an => "option", :another => "option" do
          title "awesome report!"
          sub_title "you won't need another!"
          type :svg
          height "350"
          width "250"
          x_axis_label "new x-axis label"
          y_axis_label "new y-axis label"
          columns :created_at, :pageviews
        end
        chart :the_other_chart_name do
          title "Some other chart"
        end
      end
    end

    teardown do
    end

    should "allow setting their name" do
      assert_equal :the_chart_name, TheReport.chart_with_name(:the_chart_name).name
    end

    should "allow setting their title" do
      assert_equal "awesome report!", TheReport.chart_with_name(:the_chart_name).title
    end

    should "allow setting the sub title" do
      assert_equal "you won't need another!", TheReport.chart_with_name(:the_chart_name).sub_title
    end

    should "allow setting their type" do
      assert_equal :svg, TheReport.chart_with_name(:the_chart_name).type
    end
    
    should "allow setting their width" do
      assert_equal "250" ,TheReport.chart_with_name(:the_chart_name).width
    end

    should "allow setting their height" do
      assert_equal "350", TheReport.chart_with_name(:the_chart_name).height
    end
    
    should "allow setting their x-axis label of the chart" do
      assert_equal "new x-axis label", TheReport.chart_with_name(:the_chart_name).x_axis_label
    end
    
    should "allow setting their y-axis label of the chart" do
      assert_equal "new y-axis label", TheReport.chart_with_name(:the_chart_name).y_axis_label
    end

    should "allow specification of options to the chart beyond it's attributes." do
      hash = {
          :name => :the_chart_name, 
          :an => "option", 
          :another => "option",
          :type=>:svg,
          :x_axis_label=>"new x-axis label",
          :y_axis_label=>"new y-axis label",
          :title=>"awesome report!",
          :height=>"350",
          :width=>"250",
          :sub_title=>"you won't need another!",
          :columns=>[:created_at, :pageviews]
        }
        assert_equal hash, TheReport.chart_with_name(:the_chart_name).options
    end

    should "allow definition of multiple charts" do
      #require "ruby-debug" ; debugger
      assert_contains TheReport.charts[0].name, :the_chart_name
      assert_contains TheReport.charts[1].name, :the_other_chart_name
    end

  end
end
