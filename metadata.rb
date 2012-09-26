maintainer       "Tomokazu Hirai"
maintainer_email "Tomokazu Hirai"
license          "Apache 2.0"
description      "Install a PXE install server for installing ubuntu servers using kickstart."
version          "0.0.1"

%w{ ubuntu }.each do |os|
  supports os
end
