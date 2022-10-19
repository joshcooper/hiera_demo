class dns {
  file { '/tmp/resolv.conf':
    ensure => file,
    owner => 0,
    group => 0,
    mode => "0644",
    content => "nameservers 10.240.1.10\n",
  }
}