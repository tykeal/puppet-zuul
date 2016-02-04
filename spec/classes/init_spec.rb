require 'spec_helper'
describe 'zuul' do

  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_class('zuul') }
    it { should contain_class('zuul::params') }
    it { should contain_anchor('zuul::begin') }
    it { should contain_class('zuul::install') }
    it { should contain_class('zuul::config') }
    it { should contain_class('zuul::service') }
    it { should contain_anchor('zuul::end') }
  end
end

# vi: ts=2 sw=2 sts=2 et :
