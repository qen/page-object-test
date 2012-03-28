
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

#watch("app/controllers(/.*).rb") do |match|
#  #run_spec match[0]
#  #puts match[0]
#  run_spec %{spec/#{match[1]}_spec.rb}
#end