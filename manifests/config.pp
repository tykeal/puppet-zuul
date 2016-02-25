# Class: zuul::config
# ===========================
#
# Configuration for Zuul module
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
class zuul::config (
  Hash    $config_override,
  String  $layout_config,
  Hash    $layout,
  String  $log_config,
  Hash    $logging,
  Boolean $manage_layout,
  Boolean $manage_logging,
  Boolean $manage_website,
  String  $zuul_config,
) {
  include zuul::params

  # Most folks using this will likely store their config outside of
  # puppet along with their Jenkins Job Builder definitions. This is for
  # those silly people that want to shove all of the Zuul configuration
  # into puppet.
  if $manage_layout {
    validate_absolute_path($layout_config)

    # All layouts must have a pipelines and projects sections
    unless has_key($layout, 'pipelines') {
      fail('Layout must contain pipelines definition')
    }

    unless has_key($layout, 'projects') {
      fail('Layout must contain projects definition')
    }

    file { $layout_config:
      ensure  => file,
      content => inline_template('<%= @layout.to_yaml %>')
    }
  }

  # Logging is an optional component
  if $manage_logging {
    validate_absolute_path($log_config)

    zuul::config::ini_config { $log_config:
      config_file => $log_config,
      mode        => '0644',
      options     => $logging,
    }
  }

  $zuul_config_options = merge($zuul::params::default_config_options,
    $config_override)

  zuul::config::ini_config { $zuul_config:
    config_file => $zuul_config,
    mode        => '0644',
    options     => $zuul_config_options,
  }

  if ($manage_website) {
    class { 'zuul::config::website':
    }
  }
}
