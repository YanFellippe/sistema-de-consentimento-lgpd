class User < ApplicationRecord
  has_many :consents, dependent: :destroy
  has_many :purposes, through: :consents
  validates :name, presence: { message: "não pode ficar em branco" }
  validates :email, presence: { message: "não pode ficar em branco" }, 
                    uniqueness: { message: "já está em uso" }, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "não é válido" }
  def consent_for(purpose)
    consents.find_by(purpose: purpose)
  end
end