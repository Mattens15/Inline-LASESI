class UserMailer < ApplicationMailer
  default from: "attenni.1655314@studenti.uniroma1.it"

  def account_activation(user)
    @user=user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

end
