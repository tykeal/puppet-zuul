require 'spec_helper'
describe 'zuul::install' do
  let(:facts) { {
    :fqdn            => 'my.test.com',
    :ipaddress       => '10.0.0.1',
    :osfamily        => 'RedHat',
    :operatingsystem => 'CentOS'
  } }

#  on_supported_os.each do |os, facts|
    ['pip', 'vcs'].each do |via|
      #context "on #{os} with valid parameters" do
      context "with valid parameters" do
        let (:params) {
          {
            'install_via' => via,
            'pip_package' => 'bar',
            'pip_version' => 'present',
            'group'       => 'bax',
            'user'        => 'foo',
            'user_home'   => '/foo',
            'vcs_path'    => '/vcspath',
            'vcs_source'  => 'https://foo.bar',
            'vcs_type'    => 'git',
            'venv_path'   => '/venvpath',
            'vcs_ref'     => Undef.new,
          }
        }

        it { should compile }
        it { should contain_class('zuul::install') }
        it { should contain_group(params['group']) }
        it { should contain_user(params['user']).with(
          :gid        => params['group'],
          :home       => params['user_home'],
          :managehome => true,
          :shell      => '/bin/bash',
          :require    => "Group[#{params['group']}]"
        ) }
        it { should contain_file("#{params['user_home']}/.ssh").with(
          :ensure  => 'directory',
          :owner   => params['user'],
          :group   => params['group'],
          :mode    => '0700',
          :require => "User[#{params['user']}]",
        ) }
        it { should contain_exec("Create #{params['user']}_user SSH key").with(
          :creates => "#{params['user_home']}/.ssh/id_rsa",
          :require => "File[#{params['user_home']}/.ssh]",
        ) }
        it { should contain_python__virtualenv(params['venv_path']).with(
          :ensure   => 'present',
          :owner    => 'root',
          :group    => 'root',
          :venv_dir => params['venv_path'],
          :cwd      => params['venv_path'],
        ) }
        it { should contain_class("zuul::install::#{via}").with(
          :require => "Python::Virtualenv[#{params['venv_path']}]",
        ) }
      end
    end
#  end
end

# vi: ts=2 sw=2 sts=2 et :
