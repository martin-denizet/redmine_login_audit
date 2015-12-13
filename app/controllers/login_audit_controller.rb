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