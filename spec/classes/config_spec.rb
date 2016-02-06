require 'spec_helper'
describe 'zuul::config' do

  on_supported_os.each do |os, facts|
    context "on #{os} with valid parameters" do
      let (:params) {
        {
          'config_override' => {},
          'layout_config'   => '/foo/lay.yaml',
          'layout'          => { 
            'pipelines' => 'dummy_pipeline',
            'projects'  => 'dummy_project',
          },
          'log_config'      => '/foo/log.conf',
          'logging'         => {},
          'manage_layout'   => true,
          'manage_logging'  => false,
          'zuul_config'     => '/foo/bar.conf',
        }
      }

      it { should compile }
      it { should contain_class('zuul::config') }
      it { should contain_class('zuul::params') }
      it { should contain_file(params['layout_config']).with(
        :ensure => 'file',
        :content => /(pipelines|projects)/
      ) }
      it { should_not contain_file(params['log_config']) }
      it { should contain_file(params['zuul_config']) }

      it 'should not have layout when manage_layout is false' do
        params.merge!({ 'manage_layout' => false })
        should_not contain_file(params['layout_config'])
      end

      it 'should throw an error when there is no pipeline' do
        params.merge!({ 'layout' => { 'projects' => 'dummy_project' } } )

        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
          /pipelines/)
      end

      it 'should throw an error when there is no project' do
        params.merge!({ 'layout' => { 'pipelines' => 'dummy_pipeline' } } )

        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
          /projects/)
      end

      it 'should have a logging configuration if manage_logging is true' do
        params.merge!({ 'manage_logging' => true })
        should contain_file(params['log_config'])
      end
    end
  end
end

# vi: ts=2 sw=2 sts=2 et :
