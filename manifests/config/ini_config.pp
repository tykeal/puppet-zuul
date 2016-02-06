# == Define: zuul::config::ini_config
#
# This define is a helper function for setting config options in
# zuul.conf and logger.conf
#
# Parameters
# ----------
#
# This define accepts no parameters directly
#
# Variables
# ----------
#
# [*config_file*]
#   The pariticular config file that is to be manipulated
#
# [*mode*]
#   The mode for the configuration file
#
# [*options*]
#   Hash used by the template for creating the resultant file the format
#   is as follows:
#
#   options = {
#     'section'     => {
#       'variable1' => 'Some variable',
#     },
#     'section.subsec' => {
#       'variable'     => [
#           'variable value',
#           'variable value2',
#       ],
#     },
#   }
#
# This will produce a config file similar to the following:
#
# [section]
#
# [section subsec]
#   variable = variable value
#
# Authors
# -------
#
# Andrew Grimberg <agrimberg@linuxfoundation.org>
#
# Copyright
# ---------
#
# Copyright 2015 Andrew Grimberg
#
# === License
#
# @License Apache-2.0 <http://spdx.org/licenses/Apache-2.0>
#
define zuul::config::ini_config (
  String $config_file,
  String $mode,
  Hash $options,
) {
  # input validation
  validate_absolute_path($config_file)
  validate_re($mode, '^[0-7]{4}$',
    "\"${mode}\" is not supported for mode. Allowed values are proper \
file modes.")

  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => $mode,
    content => template('zuul/ini_config.erb'),
  }
}
