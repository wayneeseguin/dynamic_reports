require "ostruct"

module DynamicReports
  module Test

    class ArrayRecords
      def self.generate(report, *options)
        records = []
        options = options.shift || {}
        (0..(options[:count].to_i)).each do |index|
          hash = {}
          report.columns.each do |column|
            hash[column.to_s] = 
            case column.to_s
            when /_at$/
              (DateTime.now-100)+index
            when /_on$/
              (Date.today-100)+index
            when /_id$/,/_count$/
              rand(10000)
            else
              column
            end
          end
          records << hash
        end
        records
      end
    end

    class ObjectRecords
      def self.generate(report,*options)
        records = []
        options = options.shift || {}
        (0..(options[:count].to_i)).each do |index|
          object = OpenStruct.new(report.columns)
          report.columns.each do |column|
            value = case column.to_s
            when /_at$/
              (DateTime.now-100)+index
            when /_on$/
              (Date.today-100)+index
            when /_id$/,/_count$/
              rand(10000)
            else
              column
            end
    
            object.send(column.to_sym, value)
    
            records << object
          end
          records
        end
      end 
    end
    
    class ARRecords
      def self.generate(*options)
      end
    end
  end

end
