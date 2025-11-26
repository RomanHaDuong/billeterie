# Billeterie - Deployment Setup Complete! 🚀

Your Rails application is now configured for automated deployment to your Raspberry Pi at **192.168.1.24**.

## 📋 What Has Been Set Up

### On Your Windows Machine
- ✅ Capistrano deployment automation
- ✅ Apache configuration files
- ✅ Deployment documentation
- ✅ Helper scripts

### Deployment Files Created
- `config/deploy.rb` - Main deployment configuration
- `config/deploy/production.rb` - Raspberry Pi specific settings
- `config/apache/billeterie.conf` - Apache virtual host configuration
- `Capfile` - Capistrano task loader
- `DEPLOYMENT.md` - Complete deployment guide
- `DEPLOY_CHECKLIST.md` - Quick reference checklist
- `setup_raspberry_pi.sh` - Automated Pi setup script
- `check_deployment.ps1` - Pre-deployment validation script

## 🚀 Quick Start

### Step 1: Check Your Local Setup
```powershell
.\check_deployment.ps1
```

### Step 2: Set Up Raspberry Pi
Transfer and run the setup script on your Pi:
```powershell
scp setup_raspberry_pi.sh pi@192.168.1.24:~
ssh pi@192.168.1.24
bash setup_raspberry_pi.sh
```

### Step 3: Push Code to GitHub
```powershell
git add .
git commit -m "Configure deployment"
git push origin master
```

### Step 4: Deploy!
```powershell
# First check
bundle exec cap production deploy:check

# Deploy
bundle exec cap production deploy

# Set up Puma service
bundle exec cap production puma:systemd:config puma:systemd:enable
```

### Step 5: Start Services on Pi
```bash
# On Raspberry Pi
sudo systemctl start puma_billeterie_production.service
sudo systemctl restart apache2
```

## 🌐 Access Your Application

- **Local Network**: http://192.168.1.24
- **Domain** (after DNS configured): http://les-ecoworkers.fr

## 📚 Documentation

- **Full Guide**: See `DEPLOYMENT.md` for complete documentation
- **Quick Reference**: See `DEPLOY_CHECKLIST.md` for quick commands
- **Troubleshooting**: Included in `DEPLOYMENT.md`

## 🔄 Regular Deployment Workflow

After making changes:
```powershell
git add .
git commit -m "Your changes"
git push origin master
bundle exec cap production deploy
```

That's it! Capistrano will automatically:
- Pull latest code from GitHub
- Install dependencies
- Run migrations
- Compile assets
- Restart Puma

## 🔧 Useful Commands

```powershell
# Deploy
bundle exec cap production deploy

# Restart app
bundle exec cap production puma:restart

# View logs
bundle exec cap production puma:log

# Rollback
bundle exec cap production deploy:rollback

# SSH to server
ssh pi@192.168.1.24
```

## ⚙️ Configuration Notes

### Apache + Puma
The app uses Apache as a reverse proxy to Puma via Unix socket. This provides better performance and allows Apache to handle static files.

### SSL/HTTPS
Initially configured for HTTP. After basic setup works:
```bash
# On Raspberry Pi
sudo certbot --apache -d les-ecoworkers.fr -d www.les-ecoworkers.fr
```

Then update `config/environments/production.rb` to enable `config.force_ssl = true`.

### Network Setup
Since your Pi is on local network (192.168.1.24):
1. Configure port forwarding on your router (ports 80 and 443 → 192.168.1.24)
2. Update domain DNS to point to your public IP

## 🆘 Troubleshooting

### Deployment fails
```powershell
bundle exec cap production deploy:check
```
This will show what's missing.

### Can't connect to Pi
```powershell
ssh pi@192.168.1.24
```
Verify SSH access before deploying.

### Site doesn't load
```bash
# On Pi
sudo systemctl status puma_billeterie_production.service
sudo systemctl status apache2
sudo tail -f /var/log/apache2/billeterie_error.log
```

## 📝 Important Files on Raspberry Pi

These files need to exist on the Pi:
- `/home/pi/apps/billeterie/shared/config/database.yml`
- `/home/pi/apps/billeterie/shared/config/master.key`
- `/home/pi/apps/billeterie/shared/.env`

The setup script creates these automatically!

## 🎉 You're All Set!

Follow the Quick Start steps above and you'll have your app running on the Raspberry Pi in no time!

For detailed information, refer to `DEPLOYMENT.md`.
