include_recipe 'common::virtualenv'

# install python and other required packages.
%w{mysql mysql-devel libmemcached libmemcached-devel libjpeg-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

include_recipe 'common::postfix'

include_recipe 'common::repository'

include_recipe 's3'

# install APNs key
s3_file node[:apns][:key_path] do
  source node[:apns][:key_s3]
  access_key_id node[:aws][:key]
  secret_access_key node[:aws][:secret]
  owner node[:app][:owner]
  group node[:app][:group]
  mode 0644
  not_if { ::File.exists?(node[:apns][:key_path]) }
end

# supervisor must be called before gunicorn and celeryd.
include_recipe 'supervisor'

include_recipe 'common::gunicorn'

include_recipe 'common::celeryd'

include_recipe 'common::celerybeat'

include_recipe 'common::nginx'

include_recipe 'common::td-agent'
# configuration
template "/etc/td-agent/td-agent.conf" do
  source 'td-agent.conf.erb'
  action :create
  # no need to notify since the template is subscribed.
end
