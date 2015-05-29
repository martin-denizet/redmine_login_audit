class LoginAudit < ActiveRecord::Base
  unloadable

  validates :user_id, :presence => true

  belongs_to :user
  
  attr_accessible :user, :ip_address, :success, :client
end
