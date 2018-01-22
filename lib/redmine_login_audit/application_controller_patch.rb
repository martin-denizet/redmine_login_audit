#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
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
        if api_request?
          user = User.current

          if Setting.rest_api_enabled? && accept_api_auth? && user && user.active? && !user.must_change_password?
            LoginAudit.success(user, request, params)
          else
            LoginAudit.failure(nil, request, params)
          end
        end

      end
    end
  end
end

ApplicationController.send(:include, RedmineLoginAudit::ApplicationControllerPatch)