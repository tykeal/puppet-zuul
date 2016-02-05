# Class: zuul::install::vcs
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
class zuul::install::vcs (
  String $vcs_path,
  String $vcs_source,
  String $vcs_type,
  String $venv_path,
  Optional[String] $vcs_ref,
) {
  vcsrepo { $vcs_path:
    ensure   => present,
    provider => $vcs_type,
    source   => $vcs_source,
    revision => $vcs_ref,
    notify   => Python::Pip['vcs_zuul'],
  }

  python::pip { 'vcs_zuul':
    ensure     => present,
    pkgname    => 'zuul',
    virtualenv => $venv_path,
    url        => $vcs_path,
    require    => Vcsrepo[$vcs_path],
  }
}

