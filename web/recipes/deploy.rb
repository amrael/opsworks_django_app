app_directory = "#{node[:app][:directory]}/#{node[:app][:host]}"

# deploy git repository.
git app_directory do
  repository node[:app][:repository]
  revision node[:app][:revision]
  user node[:app][:owner]
  group node[:app][:group]
  ssh_wrapper node[:sshignorehost][:path]
  action :sync
end


# pip install
bash "pip install -r requirements_web.txt" do
  cwd app_directory
  code <<-EOC
  #{node[:virtualenv][:path]}/bin/pip install -r requirements_web.txt
  EOC
end


# place credential files.
template "#{app_directory}/#{node[:app][:name]}/#{node[:app][:name]}/settings_base_credential.py" do
  source 'settings_base_credential.py.erb'
  action :create
end

template "#{app_directory}/#{node[:app][:name]}/#{node[:app][:name]}/#{node[:app][:credential]}" do
  source 'settings_env_credential.py.erb'
  action :create
end

# install compilers of less and coffeescript.
bash 'npm install --production' do
  cwd app_directory
  code <<-EOC
  npm install --production
  EOC
end

# grunt deploy
bash "grunt deploy" do
  cwd app_directory
  code <<-EOC
  grunt deploy
  EOC
end

# collectstatic and clearcache
bash "manage.py" do
  cwd "#{app_directory}/#{node[:app][:name]}"
  code <<-EOC
  #{node[:virtualenv][:path]}/bin/python manage.py collectstatic --noinput --settings=#{node[:app][:django_settings]}
  EOC
end

# restart supervisor services.
%W{gunicorn-#{node[:app][:name]} celeryd-#{node[:app][:name]}}.each do |srv|
  supervisor_service srv do
    action :restart
  end
end