require 'simplecov'

SimpleCov.start do
  add_filter 'vendor'
  enable_coverage :branch
  minimum_coverage 100
end
