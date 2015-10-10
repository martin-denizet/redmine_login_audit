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