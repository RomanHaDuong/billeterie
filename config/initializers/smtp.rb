ActionMailer::Base.smtp_settings = {
  domain: 'les-ecoworkers.fr',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  user_name: 'apikey', # This is literally 'apikey', not your API key
  password: ENV['SENDGRID_API_KEY'],
  enable_starttls_auto: true
}
