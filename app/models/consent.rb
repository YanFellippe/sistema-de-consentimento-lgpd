class Consent < ApplicationRecord
  belongs_to :user
  belongs_to :purpose
  enum status: { granted: 0, revoked: 1 }
  validates :user_id, uniqueness: { scope: :purpose_id }
end