#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class CreateLoginAudits < ActiveRecord::Migration
  def change
    create_table :login_audits do |t|
      t.integer :user_id
      t.boolean :success
      t.datetime :created_on
      t.string :ip_address
      t.string :client
    end
    add_index :login_audits, :user_id
    add_index :login_audits, :created_on
  end
end