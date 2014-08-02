require 'json'
#Calculates tweets_per_state from the output of 
#substance_geo.txt into a json file name substance_tweets_per_state.json

drug = "marijuana"
states = Hash.new()

f = File.readlines("#{drug}_geo.txt")

f.each do |line|
  line = line.split(' | ')
  st = line[0];
  if states.has_key?(st)
    states[st]+=1
  else
    states[st] = 1  
  end 
end

File.open("#{drug}_tweets_per_state.json","w") do |s|
  s.write(states.to_json)
end
