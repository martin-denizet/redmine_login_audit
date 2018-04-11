#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Ensure that we are using the temporary fixture path
# Engines::Testing.set_fixture_path(File.dirname(__FILE__) + '/../../../test/fixtures')
def set_login_audit_settings(opts={})
  defaults = {"log_setting" => LoginAudit::LoggingSetting::BOTH, "audit_api" => "1", "audit_api_filter_out_keys" => "1", "recipients" => [{"email" => "toto@tata.com", "web_failure" => "on", "api_failure" => "on"}, {"email" => "tata@tata.com", "web_success" => "on"}], "audit_rows_per_page" => "50"}
  opts=defaults.merge(opts)
  s = Setting.where(name: 'plugin_redmine_login_audit').first_or_initialize
  s.value = opts
  s.save!
  Setting.clear_cache
end

class LoginAuditIntegrationTests < Redmine::IntegrationTest
  def fail_log_user(login, password)
    User.anonymous
    get "/login"
    assert_nil session[:user_id]
    assert_response :success

    post "/login", :username => login, :password => password
    #assert_equal login, User.find(session[:user_id]).login
    assert_nil session[:user_id]
  end
end