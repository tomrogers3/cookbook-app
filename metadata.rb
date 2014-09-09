name             "application"
maintainer       "tomoro.io"
maintainer_email "tom@tomoro.io"
license          "All rights reserved"
description      "Installs/Configures application"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.2"

depends "docker"
depends "golang"
depends "nodejs"
