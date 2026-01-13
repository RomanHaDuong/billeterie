namespace :email do
  desc "Test email configuration by sending a test email"
  task :test, [:recipient] => :environment do |t, args|
    recipient = args[:recipient] || 'roman.haduong@gmail.com'
    
    puts "Sending test email to #{recipient}..."
    puts "Environment: #{Rails.env}"
    puts "SMTP settings:"
    puts "  Address: #{ActionMailer::Base.smtp_settings[:address]}"
    puts "  Port: #{ActionMailer::Base.smtp_settings[:port]}"
    puts "  Domain: #{ActionMailer::Base.smtp_settings[:domain] || ENV['SENDGRID_DOMAIN']}"
    puts "  API Key configured: #{ENV['SENDGRID_API_KEY'].present? ? 'Yes' : 'No'}"
    puts "  Default URL host: #{ActionMailer::Base.default_url_options[:host]}"
    puts ""
    
    begin
      TestMailer.test_email.deliver_now
      puts "✓ Email sent successfully!"
      puts "Check your inbox at #{recipient}"
    rescue => e
      puts "✗ Error sending email:"
      puts "  #{e.class}: #{e.message}"
      puts "\nBacktrace:"
      puts e.backtrace.first(5).join("\n")
    end
  end
  
  desc "Test password reset email"
  task :test_password_reset, [:email] => :environment do |t, args|
    email = args[:email] || 'admin@gmail.com'
    
    user = User.find_by(email: email)
    
    if user.nil?
      puts "✗ User with email '#{email}' not found"
      puts "Available users:"
      User.limit(5).pluck(:email).each { |e| puts "  - #{e}" }
      exit 1
    end
    
    puts "Testing password reset for user: #{user.email}"
    puts "Environment: #{Rails.env}"
    puts ""
    
    begin
      user.send_reset_password_instructions
      puts "✓ Password reset email sent successfully!"
      puts "Check your inbox at #{user.email}"
    rescue => e
      puts "✗ Error sending password reset email:"
      puts "  #{e.class}: #{e.message}"
      puts "\nBacktrace:"
      puts e.backtrace.first(5).join("\n")
    end
  end
end
