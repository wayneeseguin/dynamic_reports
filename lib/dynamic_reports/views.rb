module DynamicReports
  class View

    include Templates

    attr_accessor :template, :views, :report
    @@cached_templates = {}
    @template = {}
    @views    = {}

    def options
      @options ||= {}
    end

    def initialize(report)
      @template = report.template
      @report   = report
      @views    = report.views
    end

    class << self
      def cached_templates
        @@cached_templates
      end
    end

    # TODO: Investigate if we can remove the need for caller_locations here?
    def self.caller_locations ; [] ; end
  end
end
