# install packages 
%w{gdal proj-devel json-c postgresql95-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end
