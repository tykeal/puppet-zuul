require 'spec_helper'
describe 'zuul::install::vcs' do

  on_supported_os.each do |os, facts|
    context "on #{os} with valid parameters" do
      let (:params) {
        {
          'vcs_path'    => '/vcspath',
          'vcs_source'  => 'https://foo.bar',
          'vcs_type'    => 'git',
          'venv_path'   => '/venvpath',
          'vcs_ref'     => Undef.new,
        }
      }

      it { should compile }
      it { should contain_class('zuul::install::vcs') }
      it { should contain_vcsrepo(params['vcs_path']).with(
        :ensure   => 'present',
        :provider => params['vcs_type'],
        :source   => params['vcs_source'],
        # don't check revision for now as the version of rspec
        # we're using has issues with undef / nil
        #:revision => params['vcs_ref'],
        :notify   => 'Python::Pip[vcs_zuul]',
      ) }
      it { should contain_python__pip('vcs_zuul').with(
        :ensure     => 'present',
        :virtualenv => params['venv_path'],
        :url        => params['vcs_path'],
        :pkgname    => 'zuul',
        :require    => "Vcsrepo[#{params['vcs_path']}]",
      ) }
    end
  end
end

# vi: ts=2 sw=2 sts=2 et :
