require "rufus-scheduler"

scheduler= Rufus:Scheduler::singleton

	#scorre lista room
	room.all.each do |stanza|
		
		
		scheduler.at stanza.time_from do #bisognerebbe settare quando si vuole ricevere la mail 
			stanza.reservations.map do |relazione|
				relazione.each do |utente|
				if utente.reminder
					#send mail
					ReminderMailer.reminder_email(utente)
				end
			end
		end
	end
end

	