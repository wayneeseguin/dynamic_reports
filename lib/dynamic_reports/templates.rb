module DynamicReports
  # Options are:
  #   :layout       If set to false, no layout is rendered, otherwise
  #                 the specified layout is used
  #   :locals       A hash with local variables that should be available
  #                 in the template
  module Templates
    def csv(options={}, locals={})
      template = options.delete(:template)
      render :csv, template, options.merge!(:content_type => "csv"), locals
    end

    def erb(options={}, locals={})
      require "erb"
      template = options.delete(:template)
      render :erb, template, options, locals
    end

    def haml(options={}, locals={})
      require_warn("Haml") unless defined?(::Haml::Engine)
      template = options.delete(:template)
      render :haml, template, options, locals
    end

    def builder(options={}, locals={}, &block)
      require_warn("Builder") unless defined?(::Builder)
      template = options.delete(:template)
      options, template = template, nil if template.is_a?(Hash)
      template = lambda { block } if template.nil?
      render :builder, template, options, locals
    end

    # TODO: Add Report Helpers for injection
    def titleize(object)
      object.to_s.split('_').each{ |word| word.capitalize! }.join(' ') 
    end

    def commify(object)
      if object.is_a?(Numeric)
        object.to_s.gsub(/(\d)(?=(\d{3})+$)/,'\1,')
      else
        object
      end
    end

    def chart_url(chart,report)
      columns = chart.columns ? chart.columns : report.columns
      chart_type = chart.type.nil? ?  :line : chart.type.to_sym 
      case chart_type
      when :line
        Charts.line_chart(chart,columns,report)
      when :pie
        Charts.pie_chart(chart,columns,report)
      when :bar
        Charts.bar_column_chart(chart,columns,report,:vertical)
      when :column
        Charts.bar_column_chart(chart,columns,report,:horizontal)
      else
        raise StandardError => "Unknown chart type '#{chart.type}'."
      end

    end

    private
    
    def render(engine, template, options={}, locals={})
      # merge app-level options
      options = self.class.send(engine).merge(options) if self.class.respond_to?(engine)

      # extract generic options
      layout = options.delete(:layout)
      layout = :default_layout if (layout.nil? || layout == true)
      views  = options.delete(:views) || self.views
      content_type = options.delete(:content_type)
      locals = options.delete(:locals) || locals || {}
      locals.merge!(:report => @report, :options => options || {})
      
      # render template
      data, options[:filename], options[:line] = lookup_template(engine, template, views, content_type)
      output = __send__("render_#{engine}", template, data, options, locals)
      # render layout
      # TODO: Fix Layout Rendering & Specify Layout
      if layout
        data, options[:filename], options[:line] = lookup_layout(engine, layout, views, content_type)
        if data
          output = __send__("render_#{engine}", layout, data, options, {}) { output }
        end
      end
      output
    end

    def lookup_template(engine, template, views, content_type = nil, filename = nil, line = nil)
      content_type = "html" if content_type.nil? or content_type.blank?
      if (template.nil? || template == '')
        template = :default_template
        #views = DefaultReport.default_view_paths
      end
      case template
      when Symbol
        if cached = self.class.cached_templates[template]
          lookup_template(engine, cached[:template], views, content_type, cached[:filename], cached[:line])
        else
          filename = "#{template}.#{content_type}.#{engine}"
          dir = views.to_a.detect do |view| 
            ::File.exists?(::File.join(view, filename))
          end
          if dir
            path = ::File.join(dir, filename)
          else
            path = ::File.join(::File::dirname(::File::expand_path(__FILE__)), "views","default_report.#{content_type}.#{engine}")
          end
          [ ::File.read(path), path, 1 ]
        end
      when Proc
        filename, line = self.class.caller_locations.first if filename.nil?
        [ template.call, filename, line.to_i ]
      when String
        filename, line = self.class.caller_locations.first if filename.nil?
        [ template, filename, line.to_i ]
      else
        raise ArgumentError, "Template was not specified properly: '#{template}'."
      end
    end

    def lookup_layout(engine, template, views, content_type)
      lookup_template(engine, template, views, content_type)
    rescue Errno::ENOENT
      nil
    end

    def render_csv(template, data, options, locals, &block)
      # TODO: Implement this.
    end

    def render_erb(template, data, options, locals, &block)
      original_out_buf = defined?(@_out_buf) && @_out_buf
      data = data.call if data.kind_of? Proc

      instance = ::ERB.new(data, nil, nil, "@_out_buf")
      locals_assigns = locals.to_a.collect { |k,v| "#{k} = locals[:#{k}]" }

      filename = options.delete(:filename) || "(__ERB__)"
      line = options.delete(:line) || 1
      line -= 1 if instance.src =~ /^#coding:/

      render_binding = binding
      eval locals_assigns.join("\n"), render_binding
      eval instance.src, render_binding, filename, line
      @_out_buf, result = original_out_buf, @_out_buf
      result
    end

    def render_haml(template, data, options, locals, &block)
      ::Haml::Engine.new(data, options).render(self, locals, &block)
    end

    def render_builder(template, data, options, locals, &block)
      options = { :indent => 2 }.merge(options)
      filename = options.delete(:filename) || "<BUILDER>"
      line = options.delete(:line) || 1
      xml = ::Builder::XmlMarkup.new(options)
      if data.respond_to?(:to_str)
        eval data.to_str, binding, filename, line
      elsif data.kind_of?(Proc)
        data.call(xml)
      end
      xml.target!
    end

    def require_warn(engine)
      warn "Auto-require of #{engine} is deprecated; add require \"#{engine}\" to your app."
      require engine.downcase
    end

 
    
  end
end
