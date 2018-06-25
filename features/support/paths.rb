Before do |scenario|
  @port = Capybara.current_session.server.port
  @test_url = "http://127.0.0.1:#{@port}/"
  Capybara.default_max_wait_time = 100
end


After do |scenario|
  puts "Procedo all'eliminazione dei residui dello scenario"
  cal = Inline::Application.config.cal
  cal.delete_event('primary', @room.event_id) unless !@room
  
  #if scenario.failed?
  #  subject = "[Project X] #{scenario.exception.message}"
  #  send_failure_email(subject)
  #end
end
