require_dependency 'redmine_login_audit/hooks'

Redmine::Plugin.register :redmine_login_audit do
  name 'Redmine Login Audit plugin'
  author 'Martin DENIZET'
  description 'Login Audit logs successful login attempts, can be configured to send email'
  version '0.1.5'
  url 'https://github.com/martin-denizet/redmine_login_audit'
  author_url 'http://martin-denizet.com'

  menu :admin_menu, :login_audit, {:controller => 'login_audit', :action => 'index'}, :caption => :label_la_admin

  settings :default => {
      :notification_email => '',
      :audit_rows_per_page => 50
  },
  :partial => 'settings/login_audit'

end
