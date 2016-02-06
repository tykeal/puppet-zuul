require 'spec_helper'
describe 'zuul::service' do

  on_supported_os.each do |os, facts|
    context "on #{os} with valid parameters" do
      let (:params) {
        {
          'service_enabled' => true,
        }
      }

      it { should compile }
      it { should contain_class('zuul::service') }
      it { should contain_service('zuul') }
    end
  end
end

# vi: ts=2 sw=2 sts=2 et :
