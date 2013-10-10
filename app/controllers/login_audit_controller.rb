class LoginAuditController < ApplicationController
  unloadable

  before_filter :require_admin

  def index

    @increment = Setting.plugin_redmine_login_audit[:audit_rows_per_page].to_i
    @record_count = LoginAudit.count
    @from = params[:from].to_i || 0
    @from = 0 if  @from < 0
    @to = params[:to].to_i || @increment
    @to = @from + @increment if @to <= @from
    @audits = LoginAudit.includes(:user).limit(@increment).offset(@from).order('created_on DESC')

  end

  def purge
  end
end
