require "rake/testtask"

task :default => ["test:all"]
task :test    => ["test:all"]
namespace :test do 
  desc "Run Test Suite"
  Rake::TestTask.new("all") do |test|
    test.pattern = "test/dynamic_reports.rb"
    test.verbose = true
    test.warning = true
  end
end

desc "Build the dynamic_reports gem and then install it (NO sudo)."
task :gem do
    puts `gem uninstall dynamic_reports ; rm -f ./dynamic_reports*.gem; gem build dynamic_reports.gemspec ; gem install ./dynamic_reports*.gem --no-ri -l`
end
namespace :gem do 
  desc "Build the dynamic_reports gem."
  task :build do 
    puts `gem build gemspec.rb`
  end

  desc "Install the dynamic_reports gem (NO sudo)."
  task :install do 
    %x{gem install dynamic_reports*.gem --no-rdoc --no-ri -l}
  end
end

begin
  require "rake/rdoctask"
  require "rdoc/generator"
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = "doc"
    rdoc.title    = "Dynamic Reports"
    rdoc.options << "--line-numbers"
    rdoc.options << "--charset" << "utf-8"
    rdoc.rdoc_files.include("README.rdoc", "HISTORY")
    rdoc.rdoc_files.include("lib/*.rb")
    rdoc.rdoc_files.include("lib/dynamic_reports/*.rb")
  end
rescue
  puts "Skipping loading of rdoc tasks, missing rdoc gem."
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gemspec|
    #$VERBOSE             = nil
    gemspec.name            = "dynamic_reports"
    gemspec.summary         = "Dynamic Ruby Reporting Engine with support for Charts"
    gemspec.version         = "0.0.2"
    gemspec.require_paths   = ["lib"]
    gemspec.date            = Time.now.strftime("%Y-%m-%d")
    gemspec.description     = "Dynamic Ruby Reporting Engine with support for Charts."
    gemspec.platform        = Gem::Platform::RUBY
    gemspec.files           = ["HISTORY", "README", "dynamic_reports.gemspec", Dir::glob("lib/**/**")].flatten
    gemspec.executables     = Dir::glob("bin/*").map{ |script| File::basename script }
    gemspec.require_path    = "lib"
    gemspec.has_rdoc        = File::exist?("doc")
    gemspec.rdoc_options    = ["--inline-source", "--charset=UTF-8"]
    gemspec.authors         = ["Wayne E. Seguin","Joshua Lippiner"]
    gemspec.email           = "wayneeseguin@gmail.com, jlippiner@gmail.com"
    gemspec.homepage        = "http://dynamicreports.rubyforge.org/"
    #gemspec.test_suite_file = "test/dynamic_reports.rb" if File::directory?("test")
    #gemspec.add_dependency  "", ">= 0.0"
    gemspec.extensions      << "extconf.rb" if File::exists?("extconf.rb")
    gemspec.rubyforge_project = "dynamicreports"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

