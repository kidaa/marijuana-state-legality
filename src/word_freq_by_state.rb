require 'json'
require 'optparse'
require 'lemmatizer'
require 'tokenizer'
require 'awesome_print'
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

lem = Lemmatizer.new
toke = Tokenizer::Tokenizer.new
states = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

stop = File.readlines('./data/stopwords').map{|element| element.gsub(/\n/,'')}
f = File.open("./data/#{options[:drug]}_geo.txt").each_line do |tweet|
	
	#Each line of X_geo.txt is formatted as STATE | LAT, LONG | TEXT
	line = tweet.split(' | ')
	
	st = line[0]
	coord = line[1]
	tokenized =  toke.tokenize(line[2].downcase.delete!("^[a-z\s]")).delete_if{|token| token.include?("http")}.map{|token| lem.lemma(token)}
	#Leave only tokens separated by spaces that contain ASCII lowercase letters
	
	lemmatized_tokenized = tokenized.map{|token| lem.lemma(token)}
	freq = Hash.new(st)
	st_exists = false
	if states.has_key?(st)
		freq = states[st]
		st_exists = true
	end
	
	#change frequencies of words
	lemmatized_tokenized.each do |t|
		unless stop.include?(t)
			if freq.has_key?(t)
				freq[t]+=1
			else
				freq[t] =1
			end
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
