#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class LoginAudit < ActiveRecord::Base
  unloadable

  #validates :user_id, :presence => true

  after_create :send_notification

  before_create :filter_out_api_key
  before_create :truncate_url

  belongs_to :user

  attr_accessible :user, :ip_address, :success, :login, :api, :url, :method

  API_FORMAT = 'json'

  def source
    self.api? ? 'api' : 'web'
  end

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
    la = LoginAudit.new(
        :user => user,
        :ip_address => request.remote_ip,
        :success => success,
        #:client => request.media_type,
        :login => login,
        :api => api,
        :url => request.fullpath,
        :method => request.request_method
    )

    Rails.logger.info "LoginAudit Event: #{la.to_s}"

    begin
      la.save!
      Rails.logger.info "LoginAudit: Saved LoginAudit for User:'#{login}', id: #{id}, Login succeed: #{success}"
    rescue Exception => e
      Rails.logger.error "LoginAudit: Failed to save LoginAudit for User:'#{login}', id: #{id}, Login succeed: #{success}, Error: #{e.message}"
    end
  end

  def self.log_success?
    LoggingSetting.log_success_status.include?(Setting.plugin_redmine_login_audit['log_setting'].to_i) if Setting.plugin_redmine_login_audit['log_setting']
  end

  def self.log_failure?
    LoggingSetting.log_failure_status.include?(Setting.plugin_redmine_login_audit['log_setting'].to_i)
  end

  def send_notification
    recipients = self.class.send("recipients_for_#{api? ? 'api' : 'web'}_#{success? ? 'success' : 'failure'}")

    if recipients.any?
      begin
        Rails.logger.error "#{self.to_s} Mailing failed" unless LoginAuditMailer.login_audit_notification(
            recipients,
            self
        ).deliver
      rescue Exception => e
        Rails.logger.error "#{self.to_s} Mailing failed: #{e}"
      end
    end
  end


  def self.recipients
    unless Setting.plugin_redmine_login_audit['recipients'].nil? or Setting.plugin_redmine_login_audit['recipients'].empty?
      return Setting.plugin_redmine_login_audit['recipients']
    end
    return []
  end

  def self.recipients_for_web_success
    self.recipients.select { |r| !r['web_success'].nil? }.collect { |r| r['email'] }
  end

  def self.recipients_for_web_failure
    self.recipients.select { |r| !r['web_failure'].nil? }.collect { |r| r['email'] }
  end

  def self.recipients_for_api_success
    self.recipients.select { |r| !r['api_success'].nil? }.collect { |r| r['email'] }
  end

  def self.recipients_for_api_failure
    self.recipients.select { |r| !r['api_failure'].nil? }.collect { |r| r['email'] }
  end

  def to_s
    "LoginAudit(User #{self.user ? self.user.id : 'Unknown'} with Login:#{self.login} IP:#{ip_address} #{self.success? ? 'Succeeded' : 'Failed'} to #{self.api? ? 'call API' : 'login'} at #{url})"
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
      I18n.t(CODES_MAP[key].downcase, scope: :'settings.logging') if CODES_MAP[key]
    end
  end

  private
  # If the URL exceeds the excepted length
  def truncate_url
    self.url = self.url.truncate(255, separator: nil, omission: '[...]') if self.url
  end

  def filter_out_api_key
    if Setting.plugin_redmine_login_audit['audit_api_filter_out_keys']
      if self.url
        self.url.sub!(/key=[^\&]+/, 'key=[FILTERED]')
      end
    end
  end
end