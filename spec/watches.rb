
def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end
  
  puts ""
  puts Time.now
  puts "Running #{file}"
  puts "----------------------------------------"
  system "bundle exec rspec #{file} "
  puts ""

end

watch(".*_spec.rb") do |match|
  run_spec match[0]
end

watch("app/controllers/(.*).rb") do |match|
  run_spec %{spec/controllers/#{match[1]}_spec.rb}
end

watch("app/api/(.*).rb") do |match|
  run_spec %{spec/controllers/#{match[1]}_spec.rb}
end

#watch("app/controllers(/.*).rb") do |match|
#  #run_spec match[0]
#  #puts match[0]
#  run_spec %{spec/#{match[1]}_spec.rb}
#end

def quiter(kill_spork = true)

  spork_pid_file = File.expand_path("../../tmp/spork.pid", __FILE__)
  if File.exists?(spork_pid_file)
    spork_pid = File.read(spork_pid_file)
    puts "\n\n* spork process id #{spork_pid}"

    if kill_spork == true
      puts "* killing spork process #{spork_pid}"
      `kill -9 #{spork_pid.to_i}`
      `rm #{spork_pid_file}`
    end
  end

  puts "\n______________________________________________________________________"
  puts '"Success is going from failure to failure with no loss of enthusiasm."'
  puts '                                                 - Winston Churchill -'
  puts "d-_-b\n\n"
  exit
end

Signal.trap("INT")  { quiter }
Signal.trap("HUP")  { quiter }
Signal.trap("QUIT") { quiter }
Signal.trap("SIGTSTP") { quiter}
