# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

RedmineApp::Application.routes.draw do
  #match 'hr/:project_id/boards/:board_id/manage', :to => 'boards_watchers#manage', :via => [:get, :post]

  match 'login_audit/', :controller => 'login_audit', :action => 'index', :via => [:get]
  match 'login_audit/delete', :controller => 'login_audit', :action => 'delete', :via => [:post]
  match 'login_audit/delete_all', :controller => 'login_audit', :action => 'delete_all', :via => [:post]
end