module RedmineLoginAudit
  module Hooks
    class ControllerAccountSuccessAuthenticationAfterHook < Redmine::Hook::ViewListener
      def controller_account_success_authentication_after(context={})
        #Create the Audit record
        user = context[:user]
        request = context[:request]
        audit = LoginAudit.new(
            :user => user,
            :ip_address => request.remote_ip,
            :success => true,
            :client => request.media_type
        )
        flash[:error]= "Login Audit save failed" unless audit.save

        unless Setting.plugin_redmine_login_audit['notification_email'].nil? or Setting.plugin_redmine_login_audit['notification_email'].empty?
          begin
            flash[:error]= "Login Audit Mailing failed" unless LoginAuditMailer.login_audit_notification(
                Setting.plugin_redmine_login_audit['notification_email'],
                user,
                audit
            ).deliver
          rescue Exception => e
            flash[:error]= "Login Audit Mailing failed:"+e
          end
        end

      end
    end

    class RedmineLoginAuditHookListener < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context)
        stylesheet_link_tag 'login_audit', :plugin => :redmine_login_audit
      end
    end
  end
end