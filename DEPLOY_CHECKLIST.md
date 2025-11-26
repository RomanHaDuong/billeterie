# Quick Deployment Checklist

## Before First Deployment

### On Raspberry Pi (192.168.1.24):
- [ ] Install Ruby 3.3.5 via rbenv
- [ ] Install PostgreSQL
- [ ] Install Apache2
- [ ] Create app directories: `/home/pi/apps/billeterie/shared`
- [ ] Create database: `billeterie_production`
- [ ] Copy these files to shared directory:
  - [ ] `/home/pi/apps/billeterie/shared/config/database.yml`
  - [ ] `/home/pi/apps/billeterie/shared/config/master.key`
  - [ ] `/home/pi/apps/billeterie/shared/.env`
- [ ] Configure Apache (copy billeterie.conf)
- [ ] Enable Apache modules: proxy, proxy_http, rewrite, ssl, headers

### On Windows:
- [ ] Set up SSH key for passwordless login
- [ ] Test SSH connection: `ssh pi@192.168.1.24`
- [ ] Push code to GitHub
- [ ] Run: `bundle exec cap production deploy:check`

## Deploy Command

```powershell
# From your Windows machine
bundle exec cap production deploy
```

## Post-Deployment

```bash
# On Raspberry Pi, start Puma service
sudo systemctl enable puma_billeterie_production.service
sudo systemctl start puma_billeterie_production.service
sudo systemctl restart apache2
```

## Access Your Site
- Local: http://192.168.1.24
- Domain: http://les-ecoworkers.fr (after DNS configured)

## Quick Commands Reference

```powershell
# Deploy
bundle exec cap production deploy

# Restart
bundle exec cap production puma:restart

# Rollback
bundle exec cap production deploy:rollback

# SSH to server
ssh pi@192.168.1.24
```
