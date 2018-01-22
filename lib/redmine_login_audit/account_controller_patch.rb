#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
module RedmineLoginAudit
  module AccountControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :invalid_credentials, :login_audit
        alias_method_chain :onthefly_creation_failed, :login_audit
      end
    end

    module InstanceMethods
      def invalid_credentials_with_login_audit

        invalid_credentials_without_login_audit
        LoginAudit.failure(nil, request, params)

      end

      def onthefly_creation_failed_with_login_audit

        onthefly_creation_failed_without_login_audit
        LoginAudit.failure(nil, request, params)

      end

    end
  end
end

AccountController.send(:include, RedmineLoginAudit::AccountControllerPatch)