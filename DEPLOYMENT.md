# Deployment Guide - Billeterie to Raspberry Pi

## Prerequisites

### On Your Windows Machine
1. SSH client (OpenSSH comes with Windows 10/11)
2. Git configured with GitHub credentials
3. Bundle and Capistrano installed (already done)

### On Raspberry Pi (192.168.1.24)

#### 1. Install Required Software
```bash
# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Ruby dependencies
sudo apt-get install -y git curl libssl-dev libreadline-dev zlib1g-dev \
  autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev \
  libffi-dev libgdbm-dev nodejs postgresql postgresql-contrib libpq-dev \
  apache2 libapache2-mod-proxy-html libxml2-dev

# Install rbenv and ruby-build
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bashrc

# Install Ruby 3.3.5
rbenv install 3.3.5
rbenv global 3.3.5
gem install bundler
```

#### 2. Configure PostgreSQL
```bash
# Create database user
sudo -u postgres createuser -s pi
sudo -u postgres psql -c "ALTER USER pi WITH PASSWORD 'your_password';"

# Create production database
sudo -u postgres createdb billeterie_production -O pi
```

#### 3. Set Up Application Directory
```bash
# Create application directory
sudo mkdir -p /home/pi/apps/billeterie
sudo chown -R pi:pi /home/pi/apps/billeterie

# Create shared directories
mkdir -p /home/pi/apps/billeterie/shared/config
mkdir -p /home/pi/apps/billeterie/shared/tmp/sockets
mkdir -p /home/pi/apps/billeterie/shared/tmp/pids
mkdir -p /home/pi/apps/billeterie/shared/log
```

#### 4. Configure Database on Raspberry Pi
Create `/home/pi/apps/billeterie/shared/config/database.yml`:
```yaml
production:
  adapter: postgresql
  encoding: unicode
  database: billeterie_production
  pool: 5
  username: pi
  password: your_password
  host: localhost
```

#### 5. Set Up Environment Variables
Create `/home/pi/apps/billeterie/shared/.env`:
```bash
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key_here
SENDGRID_API_KEY=your_sendgrid_key
SENDGRID_DOMAIN=les-ecoworkers.fr
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
DATABASE_URL=postgresql://pi:your_password@localhost/billeterie_production
```

#### 6. Copy Master Key
```bash
# Copy your master key to the shared directory
# On Windows, get the key from config/master.key
# Then create it on Pi:
nano /home/pi/apps/billeterie/shared/config/master.key
# Paste your master key and save
chmod 600 /home/pi/apps/billeterie/shared/config/master.key
```

#### 7. Configure Apache
```bash
# Enable required Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

# Copy Apache configuration
sudo cp /path/to/config/apache/billeterie.conf /etc/apache2/sites-available/

# Enable the site
sudo a2ensite billeterie.conf
sudo a2dissite 000-default.conf

# Test configuration
sudo apache2ctl configtest

# Restart Apache
sudo systemctl restart apache2
```

#### 8. Set Up Puma as a Systemd Service
This will be handled automatically by Capistrano during deployment.

#### 9. Configure Firewall
```bash
# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp  # SSH
sudo ufw enable
```

## Deployment from Windows

### First Time Setup

1. **Set Up SSH Key (Recommended)**
```powershell
# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096

# Copy public key to Raspberry Pi
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh pi@192.168.1.24 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

2. **Test SSH Connection**
```powershell
ssh pi@192.168.1.24
```

3. **Push Your Code to GitHub**
```powershell
git add .
git commit -m "Prepare for deployment"
git push origin master
```

4. **Initial Deployment**
```powershell
# Check connection
bundle exec cap production deploy:check

# Deploy for the first time
bundle exec cap production deploy

# Set up Puma systemd service
bundle exec cap production puma:systemd:config puma:systemd:enable
```

### Regular Deployments

After making changes to your application:

```powershell
# Commit and push changes
git add .
git commit -m "Your commit message"
git push origin master

# Deploy to Raspberry Pi
bundle exec cap production deploy
```

### Useful Capistrano Commands

```powershell
# Check deployment configuration
bundle exec cap production deploy:check

# Roll back to previous release
bundle exec cap production deploy:rollback

# Restart Puma
bundle exec cap production puma:restart

# View logs
bundle exec cap production puma:log

# SSH into server
bundle exec cap production ssh
```

## SSL Certificate Setup (Let's Encrypt)

After everything is working with HTTP:

```bash
# On Raspberry Pi
sudo apt-get install certbot python3-certbot-apache
sudo certbot --apache -d les-ecoworkers.fr -d www.les-ecoworkers.fr

# Update Apache config to use Let's Encrypt certificates (already configured in billeterie.conf)
sudo systemctl reload apache2
```

## Monitoring and Maintenance

### View Application Logs
```bash
# On Raspberry Pi
tail -f /home/pi/apps/billeterie/current/log/production.log
tail -f /home/pi/apps/billeterie/shared/log/puma.error.log
```

### View Apache Logs
```bash
sudo tail -f /var/log/apache2/billeterie_error.log
sudo tail -f /var/log/apache2/billeterie_access.log
```

### Database Backup
```bash
# Create backup
pg_dump billeterie_production > backup_$(date +%Y%m%d).sql

# Restore backup
psql billeterie_production < backup_20231126.sql
```

## Troubleshooting

### If deployment fails:
1. Check SSH connection: `ssh pi@192.168.1.24`
2. Verify rbenv is working: `ssh pi@192.168.1.24 'which ruby'`
3. Check permissions: `ssh pi@192.168.1.24 'ls -la /home/pi/apps/billeterie'`

### If the site doesn't load:
1. Check Puma is running: `ssh pi@192.168.1.24 'systemctl status puma_billeterie_production.service'`
2. Check Apache is running: `ssh pi@192.168.1.24 'systemctl status apache2'`
3. Check Apache logs: `ssh pi@192.168.1.24 'sudo tail -f /var/log/apache2/billeterie_error.log'`

### Database connection issues:
1. Verify PostgreSQL is running: `ssh pi@192.168.1.24 'systemctl status postgresql'`
2. Check database.yml configuration
3. Verify database credentials

## Network Configuration

Since your Pi is at 192.168.1.24 (local network), you'll need to configure port forwarding on your router:
- Forward external port 80 (HTTP) to 192.168.1.24:80
- Forward external port 443 (HTTPS) to 192.168.1.24:443

Also update your domain DNS to point to your public IP address.
