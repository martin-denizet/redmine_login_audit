class LoginAudit < ActiveRecord::Base
  unloadable

  validates :user_id, presence: true

  belongs_to :user
end
