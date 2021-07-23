# @summary Class to setup cronjobs and systemd services on the management node
#
# @example
#   include protogalaxy::management_jobs.pp

class protogalaxy::management_jobs inherits protogalaxy {
  file { '/etc/systemd/system/minesweep-systemd.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('protogalaxy/minesweep-systemd.service'),
  }
  file { '/etc/systemd/system/minesweep-systemd.timer':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('protogalaxy/minesweep-systemd.timer'),
  }
  file { '/etc/systemd/system/minesweep-systemd.sh':
    ensure  => file,
    owner   => 'milky',
    group   => 'milky',
    mode    => '0755',
    content => file('protogalaxy/minesweep-systemd.sh'),
  }

  service { 'minesweep-systemd.timer':
    ensure  => running,
    enable  => true,
  }
}
