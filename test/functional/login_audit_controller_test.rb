#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
require File.expand_path('../../test_helper', __FILE__)

class LoginAuditControllerTest < ActionController::TestCase

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_index_no_records
    get :index
    assert_response :success
  end

  def test_index
    set_login_audit_settings({'log_setting' => LoginAudit::LoggingSetting::BOTH})
    20.times do
      LoginAudit.create!(user_id: User.last.id, success: true, ip_address: '127.0.0.1',
                         login: User.last.login, api: true,
                         url: '/issues.json?assigned_to_id=1&limit=50&key=a94a8fe5ccb19ba61c4c0873d391e987982fbbd3',
                         method: 'GET')
      LoginAudit.create!(user_id: User.last.id, success: true, ip_address: '127.0.0.1',
                         login: User.last.login, api: false,
                         url: '/login',
                         method: 'POST')
      LoginAudit.create!(user_id: User.last.id, success: false, ip_address: '127.0.0.1',
                         login: User.last.login, api: false,
                         url: '/login',
                         method: 'POST')
    end

    assert_not_empty LoginAudit.all
    get :index
    assert_response :success
  end
end
