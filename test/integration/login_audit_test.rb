#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
require File.expand_path('../../test_helper', __FILE__)

class LoginAuditTest < LoginAuditIntegrationTests

  self.fixture_path = File.expand_path('../../../../../test/fixtures/', __FILE__)

  fixtures :projects, :users, :email_addresses

  def test_log_login_success
    post :login, :params => {
        :username => 'jsmith',
        :password => 'jsmith',
    }
    assert_redirected_to '/my/page'
  end


  # log_user(log,pwd) expects login to be successful
  # fail_log_user(log,pwd) expects login to fail

  #Log a successful login
  def test_log_login_success
    set_login_audit_settings({'log_setting' => LoginAudit::LoggingSetting::BOTH})
    LoginAudit.destroy_all
    log_user('jsmith', 'jsmith')
    assert_not_empty LoginAudit.all
  end

  #Ignore a successful login
  def test_ignore_login_success
    set_login_audit_settings({'log_setting' => LoginAudit::LoggingSetting::FAILURES})
    LoginAudit.destroy_all
    log_user('jsmith', 'jsmith')
    assert_empty LoginAudit.all
  end

  #Log a login failure
  def test_log_login_failure
    set_login_audit_settings({'log_setting' => LoginAudit::LoggingSetting::FAILURES})
    LoginAudit.destroy_all
    fail_log_user('jsmith', 'wrong_password')
    assert_equal LoginAudit.all.size, 1
    la = LoginAudit.last
    assert_equal la.login, 'jsmith'
    assert_equal la.success, false
  end

  #Ignore a login failure
  def test_ignore_login_failure
    set_login_audit_settings({'log_setting' => LoginAudit::LoggingSetting::SUCCESSES})
    LoginAudit.destroy_all
    fail_log_user('jsmith', 'wrong_password')
    assert_empty LoginAudit.all
  end

  #Email sent on failure
  # def test_email_on_failure
  #   set_login_audit_settings(
  #       {
  #           'log_setting' => LoginAudit::LoggingSetting::FAILURES,
  #           'recipients' => [{'email' => 'test@example.net', 'web_failure' => 'on'}]
  #       }
  #   )
  #   assert_nil ActionMailer::Base.deliveries.last
  #
  #   LoginAudit.destroy_all
  #   fail_log_user('jsmith', 'wrong_password')
  #   assert_not_empty LoginAudit.all
  #   email = ActionMailer::Base.deliveries.last
  #   assert_not_nil email
  # end


end
