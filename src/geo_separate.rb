require 'json'
require 'optparse'
require 'pp'

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


#DRUG_all_out txt contains tweets for a given drug from all locales
File.open("./data/#{options[:drug]}_geo.txt",'w') do |s|
     #Avoiding readlines because it appends to an array
     f = File.open("./data/#{options[:drug]}_all_out.txt").each_line do |obj|
          if /country\"=>\"United States\"/.match(obj) 
               text = obj.split(' : ')[4].sub('source','').sub('in_reply_to_user_id','')
               coordinates = obj.split('"coordinates"=>[')[1].split(']}')[0]
               state_name = obj.split('"full_name"=>"')[1].split(',')[1].sub('"','').strip()
               s.puts("#{state_name} | #{coordinates} | #{text}")
           end
     end
end
   
