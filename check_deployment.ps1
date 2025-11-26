# Deployment Readiness Check Script
# Run this from your Windows machine

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Billeterie Deployment Readiness Check" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check 1: Git repository
Write-Host "Checking Git repository..." -ForegroundColor Yellow
if (git remote get-url origin) {
    $remoteUrl = git remote get-url origin
    Write-Host "✓ Git remote configured: $remoteUrl" -ForegroundColor Green
} else {
    Write-Host "✗ Git remote not configured" -ForegroundColor Red
}

# Check 2: Uncommitted changes
Write-Host "`nChecking for uncommitted changes..." -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠ You have uncommitted changes:" -ForegroundColor Yellow
    git status --short
    Write-Host "Run: git add . && git commit -m 'your message' && git push" -ForegroundColor Cyan
} else {
    Write-Host "✓ No uncommitted changes" -ForegroundColor Green
}

# Check 3: Master key exists
Write-Host "`nChecking for master key..." -ForegroundColor Yellow
if (Test-Path "config\master.key") {
    Write-Host "✓ Master key found" -ForegroundColor Green
    $masterKey = Get-Content "config\master.key"
    Write-Host "Your master key: $masterKey" -ForegroundColor Cyan
    Write-Host "Copy this to: /home/pi/apps/billeterie/shared/config/master.key on Pi" -ForegroundColor Cyan
} else {
    Write-Host "✗ Master key not found" -ForegroundColor Red
}

# Check 4: SSH connection to Raspberry Pi
Write-Host "`nChecking SSH connection to Raspberry Pi..." -ForegroundColor Yellow
$sshTest = ssh -o ConnectTimeout=5 -o BatchMode=yes pi@192.168.1.24 echo "connected" 2>$null
if ($sshTest -eq "connected") {
    Write-Host "✓ SSH connection successful (using SSH key)" -ForegroundColor Green
} else {
    Write-Host "⚠ SSH connection requires password or failed" -ForegroundColor Yellow
    Write-Host "Trying with password prompt..." -ForegroundColor Cyan
    $manualTest = ssh -o ConnectTimeout=5 pi@192.168.1.24 echo "connected" 2>$null
    if ($manualTest -eq "connected") {
        Write-Host "✓ SSH works with password" -ForegroundColor Green
        Write-Host "Recommended: Set up SSH key for passwordless login" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Cannot connect to Raspberry Pi" -ForegroundColor Red
        Write-Host "Check: Is Pi powered on? Is IP 192.168.1.24 correct?" -ForegroundColor Yellow
    }
}

# Check 5: Bundle and Capistrano
Write-Host "`nChecking Capistrano installation..." -ForegroundColor Yellow
$capVersion = bundle exec cap --version 2>$null
if ($capVersion) {
    Write-Host "✓ Capistrano installed: $capVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Capistrano not installed" -ForegroundColor Red
    Write-Host "Run: bundle install" -ForegroundColor Cyan
}

# Check 6: Database configuration
Write-Host "`nChecking database configuration..." -ForegroundColor Yellow
if (Test-Path "config\database.yml") {
    Write-Host "✓ database.yml exists" -ForegroundColor Green
    Write-Host "⚠ Remember to create similar file on Pi:" -ForegroundColor Yellow
    Write-Host "/home/pi/apps/billeterie/shared/config/database.yml" -ForegroundColor Cyan
} else {
    Write-Host "✗ database.yml not found" -ForegroundColor Red
}

# Summary
Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "1. Ensure Raspberry Pi is set up (see DEPLOYMENT.md)" -ForegroundColor White
Write-Host "2. Push your code: git push origin master" -ForegroundColor White
Write-Host "3. Check deployment: bundle exec cap production deploy:check" -ForegroundColor White
Write-Host "4. Deploy: bundle exec cap production deploy" -ForegroundColor White
Write-Host ""
