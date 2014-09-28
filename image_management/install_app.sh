sudo apt-get install libapache2-mod-wsgi 
sudo a2enmod wsgi

cd /var/www 

sudo mkdir FlaskApp
cd FlaskApp
sudo mkdir FlaskApp

cd FlaskApp
sudo mkdir static templates

sudo apt-get install python-pip 

sudo pip install virtualenv

sudo virtualenv venv

source venv/bin/activate 
sudo pip install Flask

deactivate



a2dissite 000-default

cd /var/www/FlaskApp
sudo service apache2 restart

