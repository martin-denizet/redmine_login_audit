class LoginAuditController < ApplicationController
  unloadable
  layout 'admin'

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

  def delete
    if params[:purge_offset] and params[:purge_offset].to_i > 0
      offset = -(params[:purge_offset].to_i)
      older_than = offset.month.from_now
      #Delete records older than offset months
      count=LoginAudit.delete_all(['created_on < ?', older_than])

      flash[:notice] = l(:notice_la_records_deleted, :count => count.to_s, :date => format_time(older_than))
    else
      flash[:error] = l(:error_la_bad_parameters)
    end

    redirect_to :action => 'index', :status => :found
  end


  def delete_all
    #Delete records
    count=LoginAudit.delete_all

    flash[:notice] = l(:notice_la_records_all_deleted, :count => count.to_s)

    redirect_to :action => 'index', :status => :found
  end

end
