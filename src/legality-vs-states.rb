require 'rubygems'
require 'json'
require 'optparse'
require 'awesome_print'
require 'set'
#Count occurence of words by categories of states, display a heatmap

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

def jaccard(one,two) #Assume that both one and two are arrays
	return (one.to_set & two.to_set).length/(one.length+two.length).to_f
end


state_categories =  JSON.parse(File.read('./data/marijuana-legality.json'))
word_frequencies_by_state = JSON.parse(File.read('./data/marijuana_word_freq_by_state.json'))
word_occurences_by_category = Hash[state_categories.keys.map{|category| [category,Array.new]}]

#In first pass, do unweighted Jaccard (ignore frequencies, just look at presence or absence)
#Group words by legal conditions rather than states
#Only taking keys for version 1.0 because computing unweighted Jaccard index
state_categories.each do |category, states|
	states.each do |state|
		lst = word_occurences_by_category[category]
		lst << if word_frequencies_by_state.key?(state) then word_frequencies_by_state[state].keys else [] end
		word_occurences_by_category[category] = lst.flatten	
	end
end

#Should lemmatize and remove extraneous symbols

similarity = Array.new(word_occurences_by_category.keys.length){Array.new(word_occurences_by_category.keys.length,0)}

word_occurences_by_category.each_with_index do |words_one, i|
	word_occurences_by_category.each_with_index do |words_two, j|
		similarity[i,j] = jaccard(words_one,words_two)
	end
end

ap similarity