require 'enumerator'

module DynamicReports
  class Chart
    def self.configure(name, *chart_options, &block)
      chart_options = chart_options.shift || {}
      chart = new(chart_options)
      chart.instance_eval(&block)
      chart.name name
      chart
    end

    def initialize(*chart_options)
      chart_options = chart_options.shift || {}
      options.merge!(chart_options)
    end

    def options
      @options ||= {} ; @options
    end

    # (Optional) Accessor used to set the chart title:
    #
    #   title "Pageviews versus Visits"
    #
    # This is displayed above the chart
    def title(value = nil)
      value ? options[:title] = value : options[:title]
    end

    # Accessor used to set or get a specific report.  Must be unique:
    #
    #   name "PV_Visits"
    #
    def name(value = nil)
      value ? options[:name] = value.to_sym : options[:name]
    end

    # (Optional) Accessor used by bar and pie charts to determine the
    # independent varible chart labels.  Due to size constraints
    # this is NOT used by column or line charts, but you can add
    # labels to the X-axis for those charts via chart_options and
    # passing Google Chart API calls."
    #
    # label_column should be a SINGLE column name from the dataset.
    #
    #   label_column "recorded_at"
    #
    def label_column(value = nil)
      value ? options[:label_column] = value : options[:label_column]
    end

    # (Optional - Default = line).  Accessor used to determine the
    # type of chart to display.  Valid options are line, column, bar
    # or pie:
    #
    #    type "bar"
    #
    def type(value = nil)
      value ? options[:type] = value : (options[:type] || :line)
    end

    # (Optional - Default = 250).  Accessor used to set the width, in pixels,
    # of the chart.
    #
    #    width "400"
    #
    def width(value = nil)
      value ? options[:width] = value : (options[:width] || "250")
    end

    # (Optional - Default = 175).  Accessor used to set the height, in pixels,
    # of the chart.
    #
    #    height "350"
    #
    def height(value = nil)
      value ? options[:height] = value : (options[:height] || "175")
    end

    # (Optional - Default = false).  Accessor used to determine if axis labels
    # should be shown.  By default y-axis labels are shown.
    #
    #    no_labels true
    #
    def no_labels(value = nil)
      value ? options[:no_labels] = value : options[:no_labels]
    end

    # (Optional) Accessor for columns
    #
    # Pass an array of symbols to define columns to chart.  Columns MUST
    # be numeric in value to chart.
    #
    # Example:
    #
    #   columns :pageviews, :visits
    #
    # You may leave this accessor blank to default to the report columns
    # specified that are numeric.
    #
    def columns(*array)
      unless array.empty?
        if (array.class == Array)
          options[:columns] = array
        else
          raise "Report columns must be specified."
        end
      else
        options[:columns]
      end
    end
  end

  # DynamicReports::Charts
  #
  #  Class used to display different chart types internally.  Charts are generated
  #  using Google Charts API
  #
  class Charts
    class << self
      # Method to select a random color from a list of hex codes
      #
      # Example: random_color()
      # => "ff0000"
      def random_color()
        color_list = %w{000000 0000ff ff0000 ffff00 00ffff ff00ff 00ff00}
        return color_list[rand(color_list.size)]
      end

      # Method to display a line chart for a given chart definition and report
      def line_chart(chart, columns, report)
        ::GoogleChart::LineChart.new("#{chart.width}x#{chart.height}", chart.title, false) do |c|
          all_data = []
          columns.each do |column|
            data = []
            report.records.each do |record|
              if record.is_a?(Hash)
                data << record[column] if record[column].is_a?(Numeric)
              elsif record.respond_to?(column.to_sym)
                data << record.send(column.to_sym) if record.send(column.to_sym).is_a?(Numeric)
              else
                data << column if column.is_a?(Numeric)
              end
            end
            c.data column, data, random_color() unless data.empty?
            all_data << data
          end
          all_data.flatten!
          c.axis :y, :range => [all_data.min,all_data.max], :color => 'ff00ff' unless chart.no_labels
          c.show_legend = columns.size > 1

          return c.to_url(chart.options)
        end
      end

      # Method to display a pie chart for a given chart definition and report
      def pie_chart(chart, columns, report)
        return if columns.size > 1 || chart.label_column.nil?
        column = columns.first.to_s

        ::GoogleChart::PieChart.new("#{chart.width}x#{chart.height}", chart.title, false) do |c|
          report.records.each do |record|
            if record.is_a?(Hash)
              c.data record[chart.label_column.to_s], record[column] if record[column].is_a?(Numeric)
            elsif record.respond_to?(column.to_sym)
              c.data record.send(chart.label_column.to_s), record.send(column.to_sym) if record.send(column.to_sym).is_a?(Numeric)
            else
              c.data chart.label_column.to_s, column if column.is_a?(Numeric)
            end
          end
          c.show_legend = false
          c.show_labels = true

          return c.to_url(chart.options)
        end
      end

      # Method to display a bar or column chart for a given chart definition and report
      def bar_column_chart(chart, columns, report, orientation)
        ::GoogleChart::BarChart.new("#{chart.width}x#{chart.height}", chart.title, orientation, true) do |c|
          all_data = []
          all_labels = []
          columns.each do |column|
            data = []
            report.records.each do |record|
              if record.is_a?(Hash)
                data << record[column] if record[column].is_a?(Numeric)
                all_labels << record[chart.label_column.to_s] if chart.label_column
              elsif record.respond_to?(column.to_sym)
                data << record.send(column.to_sym) if record.send(column.to_sym).is_a?(Numeric)
                all_labels << record.send(chart.label_column.to_s) if chart.label_column
              else
                data << column if column.is_a?(Numeric)
                all_labels << chart.label_column.to_s if chart.label_column
              end
            end
            c.data column, data, random_color() unless data.empty?
            all_data << data
          end
          all_data.flatten!

          if(orientation==:vertical)
            c.axis :y, :range => [all_data.min,all_data.max], :color => 'ff00ff' unless chart.no_labels
          else
            c.axis :x, :range => [all_data.min,all_data.max], :color => 'ff00ff'  unless chart.no_labels
            c.axis :y, :labels => all_labels
          end

          c.show_legend = columns.size > 1

          return c.to_url(chart.options)
        end
      end
    end
  end
end
