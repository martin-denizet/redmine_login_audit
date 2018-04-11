#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class UrlLimitIncrease < ActiveRecord::Migration
  def self.up
    #Limit URLs to 255 characters, IE supports 2,083 characters URLs
    change_column :login_audits, :url, :string, :limit => 255
  end

  def self.down
    change_column :login_audits, :url, :string, :limit => 155
  end
end
