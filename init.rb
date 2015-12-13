#
# Copyright (C) 2014, 2015 Martin Denizet <martin.denizet@supinfo.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The Software shall not be used nor made available to TESTTailor or any
# individual or organization related or operated by Adarsh Mehta from Germany;
# some people just don't deserve free work to be made available to them.
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require_dependency 'redmine_login_audit/application_controller_patch'
require_dependency 'redmine_login_audit/account_controller_patch'

Rails.configuration.to_prepare do
  require_dependency 'auth_source'

  require_dependency 'redmine_login_audit/hooks'

  require_dependency File.expand_path('../config/wice_grid_config', __FILE__)
end

Redmine::Plugin.register :redmine_login_audit do
  name 'Redmine Login Audit plugin'
  author 'Martin DENIZET'
  description 'Login Audit logs login attempts. Can be configured to send emails'
  version '0.2.2'
  url 'https://github.com/martin-denizet/redmine_login_audit'
  author_url 'http://martin-denizet.com'

  menu :admin_menu, :login_audit, {:controller => 'login_audit', :action => 'index'}, :caption => :label_la_admin

  requires_redmine :version_or_higher => '3.0.0'

  settings :default => {
      :log_setting => 0,
      :notification_email => '',
      :audit_rows_per_page => 50,
      :audit_api => false
  },
           :partial => 'settings/login_audit'

end