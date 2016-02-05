require 'spec_helper'
describe 'zuul::install::pip' do

  on_supported_os.each do |os, facts|
    context "on #{os} with valid parameters" do
      let (:params) {
        {
          'pip_package' => 'bar',
          'pip_version' => 'present',
          'venv_path'   => '/venvpath',
        }
      }

      it { should compile }
      it { should contain_class('zuul::install::pip') }
      it { should contain_python__pip('pip_zuul').with(
        :ensure     => params['pip_version'],
        :virtualenv => params['venv_path'],
        :pkgname    => params['pip_package'],
      ) }
    end
  end
end

# vi: ts=2 sw=2 sts=2 et :
