default['app']['owner'] = "ec2-user"
default['app']['group'] = "ec2-user"
default['app']['revision'] = 'master'
default['nginx']['cookbook'] = 'nginx'
default['nginx']['keepalive'] = 'on'
default['nginx']['keepalive_timeout'] = 2
default['gunicorn']['worker_max_requests'] = 8192
default['gunicorn']['worker_timeout'] = 60
default['td_agent']['pinning_version'] = true
default['td_agent']['version'] = '1.1.21-0'
