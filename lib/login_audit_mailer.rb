require "mailer"

class LoginAuditMailer < Mailer
  #layout 'login_audit_mailer'
  include Redmine::I18n

  def login_audit_notification(email, logged_user, login_audit)

    recipients = [email]
    @logged_user = logged_user
    @login_audit = login_audit

    mail :to => recipients,
        :subject => "#{l(:mail_la_subject, :user_name => logged_user.name, :ip_address => login_audit.ip_address, :date => format_time(login_audit.created_on))}"

  end
end