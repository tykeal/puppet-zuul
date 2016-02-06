# Class: zuul::params
# ===========================
#
# Default parameters for module
#
# Authors
# -------
#
# Andrew Grimberg <agrimberg@linuxfoundation.org>
#
# Copyright
# ---------
#
# Copyright 2016 Andrew Grimberg
#
# === License
#
# @License Apache-2.0 <http://spdx.org/licenses/Apache-2.0>
#
class zuul::params {
  # Configuration files
  $layout_config = '/etc/zuul/layout.yaml'
  $log_config    = '/etc/zuul/logging.conf'
  $zuul_config   = '/etc/zuul/zuul.conf'

  # user configuration
  $user      = 'zuul'
  $group     = $user
  $user_home = "/home/${user}"

  # virtual env info
  $venv_path = '/opt/venv-zuul'

  # installation picker
  $install_via = 'pip'

  # pip install
  $pip_package = 'zuul'
  $pip_version = 'present'

  # vcs info
  $vcs_path   = '/opt/vcs-zuul'
  $vcs_source = 'https://github.com/openstack-infra/zuul.git'
  $vcs_type   = 'git'
  $vcs_ref    = undef

  # manage layout file
  # This is useful for those situations in which the layout.yaml may
  # actually be managed by some other process.
  #
  # For instance, an OSS project that has community input on the layout
  # that is held in a publically accessible git repo.
  #
  # NOTE: the layout is a _required_ configuration for zuul, if this is
  # set to false then some other mechanism for getting the layout into
  # the proper location must be setup or zuul services will be unable to
  # start!
  $manage_layout = true

  # logging is optional and defaults to none
  $manage_logging = false

  # should the service be enabled
  $service_enabled = true

  # default config options hash
  $default_config_options = {
    'gearman'  => {
      'server' => '127.0.0.1',
    },
    'gearman_server' => {
      'start'        => true,
    },
    'zuul'            => {
      'layout_config' => '/etc/zuul/layout.yaml',
      'log_config'    => '/etc/zuul/logging.conf',
      'pidfile'       => '/var/run/zuul/zuul.pid',
      'state_dir'     => '/var/lib/zuul',
      'status_url'    => 'https://zuul.example.com/status',
    },
    'merger'     => {
      'git_dir'  => '/var/lib/zuul/git',
      'zuul_url' => 'http://zuul.example.com/p',
    },
    'gerrit'   => {
      'driver' => 'gerrit',
      'server' => 'review.example.com',
      'user'   => $user,
      'sshkey' => "${user_home}/.ssh/id_rsa",
    },
  }
}
