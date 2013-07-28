maintainer       "Tomokazu HIRAI" 
maintainer_email "Tomokazu HIRAI"
license          "Apache 2.0"
description      "Install a PXE install server for installing ubuntu servers using kickstart."
version          "0.0.2"

%w{ ubuntu debian }.each do |os|
  supports os
end
