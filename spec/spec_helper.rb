require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

class Undef
  def inspect
    'undef'
  end
end

RSpec.configure do |config|
  config.formatter = :documentation
end

at_exit { RSpec::Puppet::Coverage.report! }
