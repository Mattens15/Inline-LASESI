class ReminderMailer < ApplicationMailer
	default from: 'reminder@inline.xyz'

	def reminder_email
		@user = params[:user]
		mail(to: @user.mail,subject: "Inline | The event you signed up for is coming up!")
	end
end
