#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class AddLoginToLoginAudit < ActiveRecord::Migration
  def change
    add_column :login_audits, :login, :string
    add_column :login_audits, :api, :boolean, default: false
    add_column :login_audits, :url, :string, limit: 155
    add_column :login_audits, :method, :string, limit: 6
    remove_column :login_audits, :client, :string
  end
end
