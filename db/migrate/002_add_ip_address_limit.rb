#
# Copyright (C) 2018 Martin Denizet <martin.denizet@supinfo.com>
#
class AddIpAddressLimit < ActiveRecord::Migration
  def self.up
    # 39 for IPv6, 15 for IPv4
    change_column :login_audits, :ip_address, :string, :limit => 39
  end

  def self.down
    change_column :login_audits, :ip_address, :string, :limit => 255
  end
end
