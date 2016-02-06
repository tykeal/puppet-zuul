# Class: zuul::service
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
class zuul::service (
  Variant[Boolean, Enum['manual']] $service_enabled,
) {
  if is_bool($service_enabled) {
    $ensure = $service_enabled
  } else {
    $ensure = undef
  }

  # make sure that a notice causes a reload and not stop / start
  service { 'zuul':
    ensure  => $ensure,
    enable  => $ensure,
    restart => '/bin/systemctl reload zuul',
  }

  service { 'zuul-merger':
    ensure  => $ensure,
    enable  => $ensure,
    restart => '/bin/systemctl reload zuul-merger',
  }
}
