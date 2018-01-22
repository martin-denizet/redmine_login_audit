#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
module RedmineLoginAudit
  module Hooks
    class ControllerAccountSuccessAuthenticationAfterHook < Redmine::Hook::ViewListener
      def controller_account_success_authentication_after(context={})
        #Create the Audit record
        user = context[:user]
        request = context[:request]

        LoginAudit.success(user, request, context[:params])

      end
    end

    class RedmineLoginAuditHookListener < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context)
        stylesheet_link_tag 'login_audit', :plugin => :redmine_login_audit if context[:controller].is_a?(AdminController) or context[:controller].is_a?(SettingsController)
      end
    end
  end
end