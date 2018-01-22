#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#

# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

RedmineApp::Application.routes.draw do
  get 'login_audit/', :controller => 'login_audit', :action => 'index'
  post 'login_audit/delete', :controller => 'login_audit', :action => 'delete'
  post 'login_audit/delete_all', :controller => 'login_audit', :action => 'delete_all'
end
