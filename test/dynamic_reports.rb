#!/usr/bin/env ruby
require "rubygems"
require "test/unit/testsuite"
require "test/unit/ui/console/testrunner"
#require "test/unit/color"
require "shoulda"
require "zentest"

# Libraries
require "dynamic_reports"
require "test/test_helper"

# Test files.
require "test/dynamic_reports/charts_test"
require "test/dynamic_reports/reports_test"
require "test/dynamic_reports/views_test"

require "test/unit"
