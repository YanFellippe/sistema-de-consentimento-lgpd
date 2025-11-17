class Purpose < ApplicationRecord
  has_many :consents, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end