#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class LoginAuditController < AdminController
  unloadable
  layout 'admin'

  before_filter :require_admin

  def index

    per_page = Setting.plugin_redmine_login_audit[:audit_rows_per_page].to_i

    @records_grid = initialize_grid(LoginAudit,
                                    include: :user,
                                    name: 'login_audit',
                                    order: 'login_audits.created_on',
                                    order_direction: 'desc',
                                    per_page: per_page,
                                    enable_export_to_csv: true,
                                    csv_file_name: 'login_audit')

    export_grid_if_requested

  end

  def delete
    if params[:purge_offset] and params[:purge_offset].to_i > 0
      offset = params[:purge_offset].to_i
      older_than = offset.month.ago
      #Delete records older than offset months
      count = LoginAudit.delete_all(['created_on < ?', older_than])

      flash[:notice] = l(:notice_la_records_deleted, :count => count.to_s, :date => format_time(older_than))
    else
      flash[:error] = l(:error_la_bad_parameters)
    end

    redirect_to :action => 'index', :status => :found
  end


  def delete_all
    #Delete records
    count = LoginAudit.delete_all

    flash[:notice] = l(:notice_la_records_all_deleted, :count => count.to_s)

    redirect_to :action => 'index', :status => :found
  end

end