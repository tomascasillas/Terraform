

#!/bin/bash
sudo apt update
sudo apt-get -y install nginx
echo "<H1>Pagina creada mediante script</H1>" > /var/www/html/index.html