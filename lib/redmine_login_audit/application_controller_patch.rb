require_dependency 'application_controller'

module RedmineLoginAudit
  module ApplicationControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable

        alias_method_chain :user_setup, :login_audit
      end
    end

    module InstanceMethods
      def user_setup_with_login_audit

        user_setup_without_login_audit
        user = User.current

        if Setting.rest_api_enabled? && api_request? && accept_api_auth?
          if user && user.active? && !user.must_change_password? && Setting.plugin_redmine_login_audit['audit_api']
            audit = LoginAudit.new(
                :user => user,
                :ip_address => request.remote_ip,
                :success => true,
                :client => request.media_type
            )
            flash[:error]= "Login Audit save failed" unless audit.save
          end
        end


      end

    end
  end
end

ApplicationController.send(:include, RedmineLoginAudit::ApplicationControllerPatch)