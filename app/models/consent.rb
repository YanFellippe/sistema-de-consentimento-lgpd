class Consent < ApplicationRecord
  belongs_to :user
  belongs_to :purpose
end
