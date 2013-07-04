default['dovecot'] = {
  'conf_dir' => '/etc/dovecot/',
  'log_path' => '/var/log/dovecot.err',
  'ssl' => {
    'enabled' => 'yes',
    'ssl_cert_file' => '/etc/dovecot/dovecot.crt',
    'ssl_key_file' => '/etc/dovecot/dovecot.key'
  },
  'mail_location' => {
    'type'=>'maildir',
    'directory'=>'/var/mail/',
    'expansions'=>'%d/%n'
  },
  'imap' => {
    'mail_max_userip_connections' => '100'
  },
  'auth' => {
    'mechanisms' => 'plain',
    'passdbs' => {
      'types' => {
        'passwd-file' => '/etc/dovecot/passwd'
      }
    },
    'userdbs' => {
      'types' => {
        'static' => 'uid=vmail gid=vmail home=/var/mail/%d/%n'
      }
    },
  },
  'user' => "root"
}
default['dovecot']['passwd-file'] = node['dovecot']['auth']['passdbs']['types']['passwd-file']
