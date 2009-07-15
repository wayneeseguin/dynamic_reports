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

desc "Build the dynamic_reports gem and then install it."
task :gem do
  puts `gem uninstall dynamic_reports ; rm -f dynamic_reports-0.0.0.gem; gem build gemspec.rb ; gem install ./dynamic_reports-0.0.0.gem --no-ri -l`
end
namespace :gem do
  desc "Build the dynamic_reports gem."
  task :build do
    puts `gem build gemspec.rb`
  end

  desc "Install the dynamic_reports gem."
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
