require 'json'
require 'optparse'

#stores the frequency of words by state in a json file. 


options  = {}
optparse = OptionParser.new do |opts|
     opts.banner = "Usage: ruby geo_separate.rb [options]"

     opts.on("--d","--drug NAME","name of drug to process") do |drug|
          options[:drug] = drug
     end

     opts.on('--h','--help','Display this screen') do
          puts opts
          exit
     end
end

optparse.parse!


states = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

stop = File.readlines('./data/stopwords').map{|element| element.gsub(/\n/,'')}
f = File.readlines("./data/#{options[:drug]}_geo.txt")
f.each do |line|
  line = line.split(' | ')
  st = line[0]
  coord = line[1]
  text = line[2].split(" ")
  freq = Hash.new(st)
  st_exists = false
  if states.has_key?(st)
    freq = states[st]
    st_exists = true
  end
  
  #change frequencies of words
  text.each do |t|
    if stop.include?(t)
      next
    end
    if(st_exists)
      if freq.has_key?(t)
        freq[t]+=1
      else
        freq[t] =1
      end
    else
      freq[t]=1
    end
  end
  
  #store hash in state hash
  if(st_exists)
    states[st].update(freq)
  else
    states[st] = freq
  end
end

File.open("./data/#{options[:drug]}_word_freq_by_state.json","w") do |s|
  s.write(states.to_json)
end
