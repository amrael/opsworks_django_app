# install packages(gdal is only for installing its dependencies) 
%w{gdal proj-devel json-c postgresql95-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

# install gdal 2.1.3 using conan
gdal_version = "2.1.3"
gdal_hash = "de9c231f84c85def9df09875e1785a1319fa8cb6"

bash 'uninstall gdal and re-install its newer version with conan' do
  code <<-EOC
  sudo rpm -e --nodeps gdal
  sudo pip install conan
  export PATH=$PATH:/usr/local/bin
  conan remote add opsworks https://api.bintray.com/conan/trippiece/opsworks
  conan install Gdal/#{gdal_version}@amrael/stable -r opsworks
  sudo sh -c "echo 'export PATH=\$PATH:$HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/#{gdal_hash}/bin' > /etc/profile.d/gdal.sh"
  export PATH=$PATH:$HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/#{gdal_hash}/bin
  sudo sh -c "echo $HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/#{gdal_hash}/lib > /etc/ld.so.conf.d/gdal-#{gdal_version}.conf"
  sudo ldconfig
  EOC
  user node[:app][:owner]
  group node[:app][:group]
  environment 'HOME' => "/home/#{node[:app][:owner]}"
end
