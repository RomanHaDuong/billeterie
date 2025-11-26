#!/bin/bash
# Raspberry Pi Setup Script for Billeterie
# Run this on your Raspberry Pi as user 'pi'

set -e

echo "=================================="
echo "Billeterie Raspberry Pi Setup"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt-get update
sudo apt-get upgrade -y

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
sudo apt-get install -y git curl libssl-dev libreadline-dev zlib1g-dev \
  autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev \
  libffi-dev libgdbm-dev nodejs postgresql postgresql-contrib libpq-dev \
  apache2 libapache2-mod-proxy-html libxml2-dev

# Install rbenv
if [ ! -d "$HOME/.rbenv" ]; then
    echo -e "${YELLOW}Installing rbenv...${NC}"
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
else
    echo -e "${GREEN}rbenv already installed${NC}"
fi

# Install Ruby 3.3.5
echo -e "${YELLOW}Installing Ruby 3.3.5 (this may take a while on Raspberry Pi)...${NC}"
if ! rbenv versions | grep -q "3.3.5"; then
    rbenv install 3.3.5
    rbenv global 3.3.5
    gem install bundler
else
    echo -e "${GREEN}Ruby 3.3.5 already installed${NC}"
fi

# Configure PostgreSQL
echo -e "${YELLOW}Configuring PostgreSQL...${NC}"
sudo -u postgres psql -c "SELECT 1 FROM pg_user WHERE usename = 'pi';" | grep -q 1 || \
    sudo -u postgres createuser -s pi

echo -e "${YELLOW}Please enter a password for PostgreSQL user 'pi':${NC}"
read -s DB_PASSWORD
sudo -u postgres psql -c "ALTER USER pi WITH PASSWORD '$DB_PASSWORD';"

# Create database
sudo -u postgres psql -c "SELECT 1 FROM pg_database WHERE datname = 'billeterie_production';" | grep -q 1 || \
    sudo -u postgres createdb billeterie_production -O pi

echo -e "${GREEN}Database created successfully${NC}"

# Create application directories
echo -e "${YELLOW}Creating application directories...${NC}"
sudo mkdir -p /home/pi/apps/billeterie
sudo chown -R pi:pi /home/pi/apps/billeterie

mkdir -p /home/pi/apps/billeterie/shared/config
mkdir -p /home/pi/apps/billeterie/shared/tmp/sockets
mkdir -p /home/pi/apps/billeterie/shared/tmp/pids
mkdir -p /home/pi/apps/billeterie/shared/log

# Create database.yml
echo -e "${YELLOW}Creating database configuration...${NC}"
cat > /home/pi/apps/billeterie/shared/config/database.yml << EOF
production:
  adapter: postgresql
  encoding: unicode
  database: billeterie_production
  pool: 5
  username: pi
  password: $DB_PASSWORD
  host: localhost
EOF

echo -e "${GREEN}Database configuration created${NC}"

# Create .env file
echo -e "${YELLOW}Creating .env file...${NC}"
echo "Please enter your RAILS_MASTER_KEY:"
read -s MASTER_KEY

echo "Please enter your SENDGRID_API_KEY (or press Enter to skip):"
read -s SENDGRID_KEY

cat > /home/pi/apps/billeterie/shared/.env << EOF
RAILS_ENV=production
RAILS_MASTER_KEY=$MASTER_KEY
SENDGRID_API_KEY=$SENDGRID_KEY
SENDGRID_DOMAIN=les-ecoworkers.fr
DATABASE_URL=postgresql://pi:$DB_PASSWORD@localhost/billeterie_production
EOF

# Create master.key
echo "$MASTER_KEY" > /home/pi/apps/billeterie/shared/config/master.key
chmod 600 /home/pi/apps/billeterie/shared/config/master.key

echo -e "${GREEN}.env and master.key created${NC}"

# Configure Apache
echo -e "${YELLOW}Configuring Apache...${NC}"
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

echo -e "${YELLOW}Apache configuration file needs to be copied from your repo${NC}"
echo -e "After first deployment, copy:"
echo -e "sudo cp /home/pi/apps/billeterie/current/config/apache/billeterie.conf /etc/apache2/sites-available/"
echo -e "sudo a2ensite billeterie.conf"
echo -e "sudo a2dissite 000-default.conf"
echo -e "sudo systemctl restart apache2"

# Configure firewall
echo -e "${YELLOW}Configuring firewall...${NC}"
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
echo "y" | sudo ufw enable

echo ""
echo -e "${GREEN}=================================="
echo -e "Setup Complete!"
echo -e "==================================${NC}"
echo ""
echo "Next steps:"
echo "1. From your Windows machine, run: bundle exec cap production deploy:check"
echo "2. Deploy: bundle exec cap production deploy"
echo "3. After first deployment, configure Apache as shown above"
echo ""
echo "Database password: (saved in database.yml and .env)"
echo ""
