After do |scenario|
  # Do something after each scenario.
  # The +scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.
  puts "Procedo all'eliminazione dei residui dello scenario"
  puts "@room EVENT_ID #{@room.event_id}"
  @room.destroy
  
  if scenario.failed?
    subject = "[Project X] #{scenario.exception.message}"
    send_failure_email(subject)
  end
end
