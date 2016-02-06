require 'spec_helper'

describe 'zuul::config::ini_config', :type => :define do
  let(:title) { 'test_git_config' }

  let(:params) {
    {
      'config_file'     => '/opt/test.config',
      'options'         => {
        'testsection'   => {
          'testvar1'    => 'testvar1',
          'testvar2'    => [ 'testvar2.1', 'testvar2.2' ],
        },
        'testsection.sub' => {
          'testvar3'    => 'testvar3',
        }
      },
      'mode'            => '0440',
    }
  }

  it 'should report an error when config_file not an absolute path' do
    params.merge!({'config_file' => 'invalid_val'})
    expect { should compile }.to \
      raise_error(RSpec::Expectations::ExpectationNotMetError,
        /"invalid_val" is not an absolute path\./)
  end

  it 'should report an error when mode is not a valid file mode' do
    params.merge!({'mode' => 'invalid_val'})
    expect { should compile }.to \
      raise_error(RSpec::Expectations::ExpectationNotMetError,
        /"invalid_val" is not supported for mode\. Allowed values are proper file modes\./)
  end

  context 'config file' do
    it { is_expected.to contain_file('/opt/test.config').with(
      'mode'    => '0440',
      'content' => "[testsection]\ntestvar1=testvar1\ntestvar2=testvar2.1\ntestvar2=testvar2.2\n\n[testsection sub]\ntestvar3=testvar3\n\n",
    ) }
  end

end

# vim: sw=2 ts=2 sts=2 et :
