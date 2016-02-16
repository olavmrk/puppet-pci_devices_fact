require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  p 'in-config'
  config.mock_with :rspec
end
