class dns(String $nameservers) {
  file { '/tmp/resolv.conf':
    ensure => file,
    owner => 0,
    group => 0,
    mode => "0644",
    content => $nameservers,
  }
}