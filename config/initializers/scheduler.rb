require "rufus-scheduler"
PROMEMORIA = Hash.new 
	#scorre lista room

routine=Rufus::Scheduler.new

routine.every "5m" do
	Room.all.each do |stanza|   
		if !PROMEMORIA.key?(stanza.id)
			schedule=Rufus::Scheduler.new
			PROMEMORIA[stanza.id]=schedule

			schedule.at stanza.time_from do #bisognerebbe settare quando si vuole ricevere la mail 
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
	end
	
	#se evento non esiste più elimina il reminder
	PROMEMORIA.each do |key,value|
		Room.all.each do |s|
			if key===s.id
				break
			else
				next
      end
			promemoria[key].kill
		end
	end
end

