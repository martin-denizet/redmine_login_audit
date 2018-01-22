#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
require "mailer"

class LoginAuditMailer < Mailer
  #layout 'login_audit_mailer'
  include Redmine::I18n

  def login_audit_notification(recipients, login_audit)

    @login_audit = login_audit

    mail :to => recipients,
         :subject => "#{l(
             (login_audit.success? ? :mail_la_success_subject : :mail_la_failure_subject),
             :user_name => login_audit.login,
             :source => login_audit.source,
             :ip_address => login_audit.ip_address,
             :date => format_time(login_audit.created_on)
         )}"

  end

end