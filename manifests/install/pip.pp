# Class: zuul::install::pip
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
class zuul::install::pip (
  String $pip_package,
  String $pip_version,
  String $venv_path,
) {
  python::pip { 'pip_zuul':
    ensure     => $pip_version,
    pkgname    => $pip_package,
    virtualenv => $venv_path,
  }
}
