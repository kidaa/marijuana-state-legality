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
#formatted as Lat, Long | tweet 
File.open("./data/#{options[:drug]}_geo.txt",'w') do |s|
     #Avoiding readlines because it appends to an array
     f = File.open("./data/#{options[:drug]}_all_out.txt").each_line do |obj|
          if /country\"=>\"United States\"/.match(obj) 
               
               a = obj.split(' : ')
               coordinates = obj.split('"coordinates"=>[')[1].split(']}')[0].sub(',',' | ')
               c = obj.split('"full_name"=>"')[1].split(',')
               puts c
               d = c[1].split(', ')[1]
              
               #Could you comment this code and replace the magic constants that remain with descriptive variable names?
               spl = temp.split(', ')
               s.print d[1][0..-2] + " | " + spl[0] + "," + spl[1][0..-2]
               s.print " | "
               s.puts a[4][0..-7] + ""
           end
     end
end
   
