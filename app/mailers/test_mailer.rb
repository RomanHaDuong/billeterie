class TestMailer < ApplicationMailer
  def test_email
    mail(
      to: 'roman.haduong@gmail.com',
      subject: 'Testing SendGrid',
      body: 'This is a test email from SendGrid'
    )
  end
end
