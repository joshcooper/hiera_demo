class dns {
  file { '/tmp/resolv.conf':
    ensure => file,
    owner => 0,
    group => 0,
    mode => "0644",
    content => lookup('dns::nameservers'),
  }
}