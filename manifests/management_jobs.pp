# @summary Class to setup cronjobs and systemd services on the management node
#
# @example
#   include protogalaxy::management_jobs.pp

class protogalaxy::management_jobs inherits protogalaxy {
  file { '/etc/systemd/system/systemd-minesweep.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('common/systemd-minesweep.service'),
  }
  file { '/etc/systemd/system/systemd-minesweep.timer':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('common/systemd-minesweep.timer'),
  }
  file { '/etc/systemd/system/systemd-minesweep.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('common/systemd-minesweep.sh'),
  }
  service { 'systemd-minesweep.timer':
    ensure  => running,
    enable  => true,
  }
}
