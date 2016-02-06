# Class: zuul
# ===========================
#
# Manages OpenStack zuul.
#
# Parameters
# ----------
#
#
# Variables
# ----------
#
#
# Examples
# --------
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
class zuul (
  Hash    $config_override  = {},
  String  $group            = $zuul::params::group,
  Enum['pip', 'vcs'] $install_via = $zuul::params::install_via,
  String  $layout_config    = $zuul::params::layout_config,
  Hash    $layout           = {},
  String  $log_config       = $zuul::params::log_config,
  Hash    $logging          = $zuul::params::default_logging,
  Boolean $manage_layout    = $zuul::params::manage_layout,
  Boolean $manage_logging   = $zuul::params::manage_logging,
  String  $pip_package      = $zuul::params::pip_package,
  String  $pip_version      = $zuul::params::pip_version,
  Variant[Boolean, Enum['manual']] $service_enabled =
                              $zuul::params::service_enabled,
  String  $user             = $zuul::params::user,
  String  $user_home        = $zuul::params::user_home,
  String  $vcs_path         = $zuul::params::vcs_path,
  String  $vcs_source       = $zuul::params::vcs_source,
  String  $vcs_type         = $zuul::params::vcs_type,
  Optional[String] $vcs_ref = $zuul::params::vcs_ref,
  String  $venv_path        = $zuul::params::venv_path,
  String  $zuul_config      = $zuul::params::zuul_config,
) inherits zuul::params {

  anchor { 'zuul::begin': }
  anchor { 'zuul::end': }

  class { 'zuul::install':
    install_via => $install_via,
    pip_package => $pip_package,
    pip_version => $pip_version,
    group       => $group,
    user        => $user,
    user_home   => $user_home,
    vcs_path    => $vcs_path,
    vcs_source  => $vcs_source,
    vcs_type    => $vcs_type,
    vcs_ref     => $vcs_ref,
    venv_path   => $venv_path,
    # in case of upgrades
    notify      => Class['zuul::service'],
  }

  class { 'zuul::config':
    config_override => $config_override,
    layout_config   => $layout_config,
    layout          => $layout,
    log_config      => $log_config,
    logging         => $logging,
    manage_layout   => $manage_layout,
    manage_logging  => $manage_logging,
    zuul_config     => $zuul_config,
  }

  class { 'zuul::service':
    service_enabled => $service_enabled,
  }

  Anchor['zuul::begin'] ->
    Class['zuul::install'] ->
    Class['zuul::config'] ~>
    Class['zuul::service'] ->
  Anchor['zuul::end']
}
