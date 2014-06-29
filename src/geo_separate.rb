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
     f = File.readlines("./data/#{options[:drug]}_all_out.txt")
     f.each do |obj|
          if /country\"=>\"United States\"/.match(obj) 
               a = obj.split(' : ')
               b = obj.split('"coordinates"=>[')
               c = obj.split('"full_name"=>"')
               d = c[1].split(', ')
               temp = ""
                    b[1].each_char do |i|
          #         creates a string to split
                         if !/\[/.match(i)
                              temp.concat i 
                         end
                         break if /\]/.match(i)     
                    end

               #Could you comment this code and replace the magic constants that remain with descriptive variable names?
               spl = temp.split(', ')
               s.print d[1][0..-2] + " | " + spl[0] + "," + spl[1][0..-2]
               s.print " | "
               s.puts a[4][0..-7] + ""
           end
     end
end
   
