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
  file { '/etc/logrotate.d/minesweep-systemd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('protogalaxy/minesweep-systemd'),
  }
# You will need to run `sudo systemctl start minesweep-systemd.service` to properly start the timer
  service { 'minesweep-systemd.timer':
    enable  => true,
  }


  cron::job { 'cluster-upgrade-reminder':
    minute      => '0',
    hour        => '8',
    date        => '1',
    month       => '*/4',
    weekday     => '*',
    command     => '/home/milky/galaxy-control-repo/cronjob/cluster-upgrade-reminder.sh',
    mode        => '0644'
  }
  cron::monthly { 'monthly-zfs-report':
    minute  => '10',
    hour    => '8',
    date    => '1',
    command => '/home/milky/galaxy-control-repo/cronjob/monthly-zfs-report.py',
    mode        => '0644'
  }
  cron::daily { 'constant-zfs-check':
    minute  => '0',
    hour    => '0',
    command => '/home/milky/galaxy-control-repo/cronjob/constant-zfs-check.py',
    mode        => '0644'
  }
}
