require_dependency 'redmine_login_audit/hooks'

Redmine::Plugin.register :redmine_login_audit do
  name 'Redmine Login Audit plugin'
  author 'Martin DENIZET'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu :admin_menu, :login_audit, {:controller => 'login_audit', :action => 'index'}, :caption => :label_la_admin

  settings :default => {
      :notification_email => '',
      :audit_rows_per_page => 50
  },
  :partial => 'settings/login_audit'

end
