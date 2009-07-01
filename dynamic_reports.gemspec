# -*- encoding: utf-8 -*-
require "rubygems"

library="dynamic_reports"
version="0.0.2"

Gem::Specification::new do |spec|
  #$VERBOSE             = nil
  spec.name            = library
  spec.summary         = library
  spec.version         = version
  spec.require_paths   = ["lib"]
  spec.date            = Time.now.strftime("%Y-%m-%d")
  spec.description     = "Dynamic Ruby Reporting Engine with support for Charts"
  spec.platform        = Gem::Platform::RUBY
  spec.files           = ["HISTORY", "README", "dynamic_reports.gemspec", Dir::glob("lib/**/**")].flatten
  spec.executables     = Dir::glob("bin/*").map{ |script| File::basename script }
  spec.require_path    = "lib"
  spec.has_rdoc        = File::exist?("doc")
  spec.rdoc_options    = ["--inline-source", "--charset=UTF-8"]
  spec.authors         = ["Wayne E. Seguin","Joshua Lippiner"]
  spec.email           = "wayneeseguin@gmail.com, jlippiner@gmail.com"
  spec.homepage        = "http://dynamicreports.rubyforge.org/"
  # spec.test_suite_file = "test/#{library}.rb" if File::directory?("test")
  #spec.add_dependency  "", ">= 0.0"
  spec.extensions      << "extconf.rb" if File::exists?("extconf.rb")
  spec.rubyforge_project = "dynamicreports"
  spec.rubygems_version  = "1.3.0"
  spec.required_rubygems_version = Gem::Requirement.new(">= 1.3.0") if spec.respond_to? :required_rubygems_version=
end
