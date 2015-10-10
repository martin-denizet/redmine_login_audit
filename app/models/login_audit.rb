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
class LoginAudit < ActiveRecord::Base
  unloadable

  #validates :user_id, :presence => true

  after_create :send_notification

  belongs_to :user

  attr_accessible :user, :ip_address, :success, :login, :api, :url, :method

  API_FORMAT = 'json'

  def self.success(user, request, params={})
    LoginAudit.log(user, true, request, params) if log_success?
  end

  def self.failure(user, request, params={})
    LoginAudit.log(user, false, request, params) if log_failure?
  end

  def self.log(user, success, request, params)
    login = user.nil? ? (params.nil? ? 'Unknown' : params['username']) : user.login
    id = user.nil? ? 'N/A' : user.id
    api = request.format === API_FORMAT
    # Setting.plugin_redmine_login_audit['audit_api']
    begin
      LoginAudit.create!(
          :user => user,
          :ip_address => request.remote_ip,
          :success => success,
          #:client => request.media_type,
          :login => login,
          :api => api,
          :url => request.fullpath,
          :method => request.request_method

      )
      Rails.logger.info "LoginAudit: Saved login audit for User:'#{login}', id: #{id}, Login succeed: #{success}"
    rescue Exception => e
      Rails.logger.error "LoginAudit: Failed to save login audit for User:'#{login}', id: #{id}, Login succeed: #{success}, Error: #{e.message}"
    end
  end

  def self.log_success?
    LoggingSetting.log_success_status.include?(Setting.plugin_redmine_login_audit['log_setting'].to_i) if Setting.plugin_redmine_login_audit['log_setting']
  end

  def self.log_failure?
    LoggingSetting.log_failure_status.include?(Setting.plugin_redmine_login_audit['log_setting'].to_i)
  end

  def send_notification
    if success?
      unless Setting.plugin_redmine_login_audit['notification_email'].nil? or Setting.plugin_redmine_login_audit['notification_email'].empty?
        begin
          flash[:error]= 'Login Audit Mailing failed' unless LoginAuditMailer.login_audit_notification(
              Setting.plugin_redmine_login_audit['notification_email'],
              user,
              audit
          ).deliver
        rescue Exception => e
          flash[:error]= "Login Audit Mailing failed: #{e}"
        end
      end
    else

    end
  end


  class LoggingSetting

    def self.to_dropdown
      KEYS.collect { |k| [get_name(k), k] }
    end

    def self.log_success_status
      [SUCCESSES, BOTH]
    end

    def self.log_failure_status
      [FAILURES, BOTH]
    end

    KEYS = [
        NOTHING = 0,
        SUCCESSES = 1,
        FAILURES = 2,
        BOTH = 3,
    ]

    NAMES_ARRAY = [
        [NOTHING, 'nothing'],
        [SUCCESSES, 'successes'],
        [FAILURES, 'failures'],
        [BOTH, 'both'],
    ]
    NAMES_MAP = Hash[NAMES_ARRAY.collect { |i| i.reverse }]
    CODES_MAP = Hash[NAMES_ARRAY]

    def self.keys
      KEYS
    end

    def self.get_name(key)
      I18n.t(CODES_MAP[key].downcase, scope: :'settings.logging') if  CODES_MAP[key]
    end
  end

end