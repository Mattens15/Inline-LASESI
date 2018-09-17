require "rufus-scheduler"

	#scorre lista room

routine=Rufus::Scheduler.new

routine.every "5m" do
	puts "Checking if reminders need to be sent!".yellow
	Room.all.each do |stanza|   
		if stanza.time_from.past?
			stanza.reservations.each do |r|
				
				if r.reminder
					user=User.find_by(id:r.user_id)
					ReminderMailer.reminder_email(user)
					puts"Sending a reminder to #{user}...".green
				end
			
			end
		end		
	end
	
end

routine.every '1day' do
	puts 'Cleaning up expired rooms...'.cyan
	tollerance = Time.now + 60 * 60 * 24 * 7 #NEXT WEEK
	Room.all.each do |r|
		r.destroy! if tollerance < r.time_to
	end
	puts '...Done!'
end