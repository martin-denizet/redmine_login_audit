#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
require File.expand_path('../../test_helper', __FILE__)

class LoginAuditTest < ActiveSupport::TestCase

  self.fixture_path = File.expand_path('../../../../../test/fixtures/', __FILE__)

  fixtures :projects, :users, :email_addresses

  def test_url_truncate
    set_login_audit_settings('log_setting' => LoginAudit::LoggingSetting::BOTH)
    la=LoginAudit.create!(user_id: User.last.id, success: true, ip_address: "127.0.0.1",
                          login: "admin", api: true,
                          url: '/projects/operations/easy_gantt/issues.json?f%5B%5D=status_id&'+
                              'key=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3&op%5Bstatus_id%5D=o&set_filter=1&type=EasyGantt%3A%3AEasyGanttIssueQuery&v%5Bstatus_id%5D%5B%5D=&'+
                              'sample_param1=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3&'+
                              'sample_param2=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3&'+
                              'sample_param3=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3&'+
                              'sample_param4=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3&'+
                              'sample_param5=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3',
                          method: "GET")
    assert_equal 255, la.url.length
  end

  def test_key_filter_api_url_
    set_login_audit_settings({
                                 'log_setting' => LoginAudit::LoggingSetting::BOTH,
                                 'audit_api_filter_out_keys' => true})
    la=LoginAudit.create!(user_id: User.last.id, success: true, ip_address: "127.0.0.1",
                          login: "admin", api: true,
                          url: "/issues.json?assigned_to_id=1&limit=50&key=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
                          method: "GET")
    assert_equal '/issues.json?assigned_to_id=1&limit=50&key=[FILTERED]', la.url
  end

end
