require "rufus-scheduler"

	#scorre lista room

routine=Rufus::Scheduler.new

routine.every "5m" do
	puts "Checking if reminders need to be sent!".yellow
	Room.all.each do |stanza|   
		if stanza.date_from.past?
			s.reservations.map do |r|
				r.each do |user|
					if user.reminder
						ReminderMailer.reminder_email(user)
						puts"Sending a reminder to #{user.username}..."
					end
				end
			end
		end		
	end
	
end

routine.every '1day' do
	puts 'Cleaning up expired rooms...'
	tollerance = Time.now + 60 * 60 * 24 * 7 #NEXT WEEK
	Room.all.each do |r|
		r.destroy! if tollerance < r.time_to
	end
	puts '...Done!'
end