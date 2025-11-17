class User < ApplicationRecord
  has_many :consents, dependent: :destroy
  has_many :purposes, through: :consents
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  def consent_for(purpose)
    consents.find_by(purpose: purpose)
  end
end