Before do |scenario|
  @port = Capybara.current_session.server.port
  @localhost_url = "http://127.0.0.1:#{@port}/"
  Capybara.default_max_wait_time = 5
end


After do |scenario|
  # Do something after each scenario.
  # The +scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.
  puts "Procedo all'eliminazione dei residui dello scenario"
  cal = Inline::Application.config.cal
  cal.delete_event('primary', @room.event_id) unless !@room
  
  #if scenario.failed?
  #  subject = "[Project X] #{scenario.exception.message}"
  #  send_failure_email(subject)
  #end
end
