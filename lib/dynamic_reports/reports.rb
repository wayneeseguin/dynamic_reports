# DynamicReports
#
# Dynamic Reporting Engine for Ruby / Rails
module DynamicReports

  # DynamicReports::Report
  # 
  class Report
    @@default_engine = "erb"

    attr_accessor :name, :title, :sub_title, :columns, :charts, :records, :template, :class_name, :styles, :links

    # views accessor, array of view paths.
    def views
      @views
    end

    # options accessor, all report options and configuration is stored in this.
    def options
      @options
    end

    class << self
      # Views setter and accessor.
      def views(*array)
        @views ||= ["#{File::dirname(File::expand_path(__FILE__))}/views/"]
        unless array.empty?
          @views.unshift(array)
          @views.flatten!
          @views.uniq!
        else
          @views
        end
      end
     
      # class level options accessor
      def options
        @options ||= {}
      end

      # class level name accessor & setter
      # 
      # Set the name of the report, for example: 
      #
      #   name "Orders Report"
      #
      def name(value = nil)
        if value 
          options[:name] = value
        else 
          # TODO: snake_case_the_name
          options[:name] || self.class.name
        end
      end
      
      # Accessor used to set the title:
      #
      #   title "All orders for the account"
      #
      # Or to access the already set title:
      #
      #   OrdersReport.title
      # 
      #   #=> "All orders for the account"
      #
      def title(value = nil)
        value ? options[:title] = value : options[:title]
      end
      
      # Accessor used to set the sub title:
      #
      #   sub_title "All orders for the account"
      #
      # Or to access the already set sub title:
      #
      #   OrdersReport.sub_title
      # 
      #   #=> "All orders for the account"
      #
      def sub_title(value = nil)
        value ? options[:sub_title] = value : options[:sub_title]
      end

      def styles
        options[:styles] ||= false
      end

      def class_name(value = nil)
        if value
          options[:class_name] = value
        elsif options[:class_name].empty?
          options[:class_name] = self.to_s
        else
          options[:class_name]
        end
      end
      
      # Accessor for the template to use for the report.
      #
      # Example:
      #
      #   template :orders # => renders orders.html.erb (erb is the default engine)
      #
      # Used without argument returns the template set for the report.
      #
      #   OrdersReport.template # => :orders
      #
      def template(value = nil)
        if value
          @template = value
          options[:template] = @template
        end
        @template ||= nil
      end

      # Accessor for columns
      #
      # Pass an array of symbols to define columns on the report
      #
      # Example:
      #
      #   columns :total, :created_at
      #
      # Calling the class method with no arguments will return an array with the defined columns.
      #
      # Example:
      #
      #   OrdersReport.columns
      #
      #   # => [:total, :created_at]
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

      # Return the chart with the specified name, if it exists. nil otherwise.
      def chart_with_name(name)
        options[:charts].to_a.detect{ |c| c.name == name.to_sym }
      end

      # Return an array of charts defined for the report.
      def charts(object=nil)
        options[:charts] ||= [] 
        options[:charts] << object if object
        options[:charts]
      end

      # Define a chart for the report
      #
      # Example:
      #   chart :PV_Visits, {:grxl => 'xxxxx'} do
      #     title "Pageviews and Visits"
      #     columns [:pageviews, :visits]
      #     no_labels false
      #     label_column "recorded_at"
      #     width "400"
      #     height "350"
      #     type "line"
      #   end
      # 
      def chart(name, *chart_options, &block)
        chart_options = chart_options.shift || {}
        charts(Chart.configure(name, chart_options, &block))
      end
      
      # Return an array of links defined for the report.
      def links(object=nil)
        options[:links] ||= []
        options[:links] << object if object
        options[:links]
      end
      
      # Define a link for the report
      #
      # Pass parameters within {}.  Parameters are replaced with the row values 
      # from passed records.  You do NOT need to include a parameter value as a 
      # report column for it to be used in a link. For example, you might 
      # want to generate a link with an ID field in it but not display that id 
      # in the actual report.  Just include {id} to do this.
      #
      # Example:
      #
      # link :visits, '/reports/{visit}/details?date={recorded_at}'
      #
      def link(column, url, link_options=nil)
        links({:column => column, :url => url, :link_options => link_options})
      end
      
      # Define an inline subreport for the report
      #
      # Pass parameters within {}.  Parameters are replaced with the row values 
      # from passed records.  You do NOT need to include a parameter value as a 
      # report column for it to be used in a link. For example, you might 
      # want to generate a subreport with an ID field in it but not display that id 
      # in the actual report.  Just include {id} to do this.
      #
      # Example:
      #
      # subreport :visits, '/reports/{visit}/details?date={recorded_at}'
      #
      # The subreport should be created using the same report definition style 
      # that you use for any other report.  
      # 
      def subreport(column, url, link_options=nil)
        link_options ||= {}
        link_options.merge!({:class => 'sub_report_link'}) 
        links({:column => column, :url => url, :link_options => link_options})
      end

      # Method for instanciating a report instance on a set of given records.
      #
      # Example:
      #
      # OrdersReport.on(@records)
      #
      # Where @records is an array of
      #
      # * Objects that respond to methods for all columns defined on the report
      # * Hashes that have keys corresponding to all columns defined on the report
      #
      # This will return an instance of the OrdersReport bound to @records
      #
      def on(records)
        new(records, @options)
      end
    end

    # Instantiate the report on a set of records.
    #
    # Example:
    #
    # OrdersReport.new(@records)
    #
    # options is a set of optional overrides for 
    #
    # * views - Used to override the class defined views.
    # * template - Used to override the class defined template.
    #
    def initialize(records, *new_options)
      new_options  = new_options.shift || {}
      @records = records

      @views = self.class.views
      @views.unshift(new_options.delete(:views)) if new_options[:views]
      @views.flatten!
      @views.uniq!

      @template = self.class.template
      @template = new_options.delete(:template) if new_options[:template]

      @options = self.class.options.merge!(new_options)
      @options.each_pair do |key,value|
        if key == "chart"
          # TODO: erh?
          self.chart(value[:name],{},value)
        else
          instance_variable_set("@#{key}".to_sym, value)
        end
      end
    end

    # Convert an instance of a report bound to a records set to an html view
    #
    # Example
    #
    # OrdersReport.on(@records).to_html
    #
    # [options]
    #   :engine - one of  :erb, :haml, :csv, :pdf
    #
    # Note: CSV & PDF forthcoming.
    #
    def to_html(*options)
      view    = View.new(self)
      # todo: this is not clean...
      options = (options.shift || {}).merge!(@options || {})
      # todo: if rails is loaded set the default engine: dynamicreports::report.default_engine
      engine  = options.delete(:engine) || @@default_engine
      options[:template] = self.class.template
      view.__send__("#{engine}", options)
    end

    # Not Implemented Yet
    def to_csv
      # TODO: Write csv hook
    end

    # Not Implemented Yet
    def to_pdf
      # TODO: Write pdf hook
    end

  end

end

