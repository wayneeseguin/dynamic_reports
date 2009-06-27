require "rubygems"

library="dynamic_reports"
version="0.0.1"

Gem::Specification::new do |spec|
  $VERBOSE             = nil
  spec.name            = library
  spec.summary         = library
  spec.version         = version
  spec.description     = "Dynamic Ruby Reporting Engine with support for Charts"
  spec.platform        = Gem::Platform::RUBY
  spec.files           = ["HISTORY", "README", "gemspec.rb", Dir::glob("lib/**/**")].flatten
  spec.executables     = Dir::glob("bin/*").map{ |script| File::basename script }
  spec.require_path    = "lib"
  spec.has_rdoc        = File::exist?("doc")
  spec.author          = "Wayne E. Seguin & Joshua Lippiner"
  spec.email           = "wayneeseguin@gmail.com, jlippiner@gmail.com"
  spec.homepage        = "http://github.com/wayneeseguin/direct_reports"
  # spec.test_suite_file = "test/#{library}.rb" if File::directory?("test")
  #spec.add_dependency  "", ">= 0.0"
  spec.extensions      << "extconf.rb" if File::exists?("extconf.rb")
  spec.rubyforge_project = library
end
