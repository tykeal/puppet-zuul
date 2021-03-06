# Class: zuul::install
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
class zuul::install (
  String $group,
  Boolean $manage_website,
  String $user,
  String $user_home,
  String $vcs_path,
  String $vcs_source,
  String $vcs_type,
  String $venv_path,
  Optional[String] $vcs_ref,
) {
  validate_absolute_path($user_home)

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure     => present,
    gid        => $group,
    home       => $user_home,
    managehome => true,
    shell      => '/bin/bash',
    require    => Group[$group],
  }

  file { "${user_home}/.ssh":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0700',
    require => User[$user],
  }

  exec { "Create ${user}_user SSH key":
    path    => '/usr/bin',
    command => "ssh-keygen -t rsa -N '' -f ${user_home}/.ssh/id_rsa -C 'Zuul'",
    creates => "${user_home}/.ssh/id_rsa",
    user    => $user,
    require => File["${user_home}/.ssh"],
  }

  python::virtualenv { $venv_path:
    ensure   => present,
    owner    => 'root',
    group    => 'root',
    venv_dir => $venv_path,
    cwd      => $venv_path,
  }

  class { 'zuul::install::vcs':
    vcs_path   => $vcs_path,
    vcs_source => $vcs_source,
    vcs_type   => $vcs_type,
    vcs_ref    => $vcs_ref,
    venv_path  => $venv_path,
    require    => Python::Virtualenv[$venv_path],
  }

  file { 'zuul_systemd_script':
    ensure  => file,
    path    => '/usr/lib/systemd/system/zuul.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('zuul/service.epp', {
      user        => $user,
      group       => $group,
      venv_path   => $venv_path,
      prog        => 'zuul-server',
      description => 'Zuul Server',
      signal      => 'SIGUSR1',
    } ),
  }

  file { 'zuul_merger_systemd_script':
    ensure  => file,
    path    => '/usr/lib/systemd/system/zuul-merger.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('zuul/service.epp', {
      user        => $user,
      group       => $group,
      venv_path   => $venv_path,
      prog        => 'zuul-merger',
      description => 'Zuul Merger',
      signal      => 'SIGTERM',
    } ),
  }

  # support directories
  file { [
      '/etc/zuul',
      '/var/lib/zuul',
      '/var/lib/zuul/git',
    ]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  file { '/var/log/zuul':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0770',
  }

  if ($manage_website) {
    class { 'zuul::install::website':
    }
  }
}
