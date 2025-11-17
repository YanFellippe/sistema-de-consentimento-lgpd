class ConsentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def toggle
    @user = User.find(params[:user_id])
    @purpose = Purpose.find(params[:purpose_id])
    
    new_status = params[:status]

    consent = Consent.find_or_initialize_by(user: @user, purpose: @purpose)

    if new_status == 'granted'
      consent.status = :granted
      consent.granted_at = Time.current
      consent.revoked_at = nil
    elsif new_status == 'revoked'
      consent.status = :revoked
      consent.revoked_at = Time.current
    end

    if consent.save
      redirect_to user_path(@user, t: Time.now.to_i), notice: "Consentimento de '#{@purpose.name}' foi atualizado."
    else
      redirect_to user_path(@user), alert: "Erro ao atualizar consentimento: #{consent.errors.full_messages.join(', ')}"
    end
  end

  def history
    @user = User.find(params[:user_id])
    @consents = @user.consents.includes(:purpose).order(updated_at: :desc)
  end
end