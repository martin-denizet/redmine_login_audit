#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
require_dependency 'redmine_login_audit/application_controller_patch'
require_dependency 'redmine_login_audit/account_controller_patch'

Rails.application.config.assets.precompile += %w( wice_grid.js )

Rails.configuration.to_prepare do

  require_dependency 'auth_source'

  require_dependency 'redmine_login_audit/hooks'

  require_dependency File.expand_path('../config/wice_grid_config', __FILE__)

  #Migration for settings from version <= 0.2.4
  settings = Setting.plugin_redmine_login_audit
  if settings['notification_email']
    recipients = settings['recipients']
    recipients = [] if recipients.nil? || recipients.empty?
    recipients << {'email' => settings['notification_email'], 'web_success' => 'on'} unless settings['notification_email'].nil? || settings['notification_email'].empty?

    settings['recipients'] = recipients
    settings['notification_email'] = nil

    Setting.plugin_redmine_login_audit = settings
  end

end

Redmine::Plugin.register :redmine_login_audit do
  name 'Redmine Login Audit plugin'
  author 'Martin DENIZET'
  description 'Login Audit logs login attempts. Can be configured to send emails'
  version '0.3.3'
  url 'https://github.com/martin-denizet/redmine_login_audit'
  author_url 'http://martin-denizet.com'

  menu :admin_menu, :login_audit, {:controller => 'login_audit', :action => 'index'}, :caption => :label_la_admin, html:{'class'=>'icon'}

  requires_redmine :version_or_higher => '3.0.0'

  settings :default => {
      :log_setting => 0,
      :recipients => [],
      :audit_rows_per_page => 50,
      :audit_api => false
  },
           :partial => 'settings/login_audit'

end