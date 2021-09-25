def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first  
end 
def  parse_dns(dns_raw)
  dns1 = Array.new
  line =0
  while line <dns_raw.length  
      if  dns_raw[line].include? "#" or dns_raw[line].length==1
          line = line +1
      else   
          str1 = dns_raw[line].delete(",")
          strings = str1.split
          dns1.push(strings)
          line = line +1
      end
  end 
  return dns1
end 

def resolve(dns_records, lookup_chain, domain) 
  found1 =0
  dns_records.each do |arr|      
      arr.each do |inner|            
          if inner.include? "A" and arr[1] ==domain  
              found1 =1      
              return lookup_chain.push(arr[2])        
          end
      end
  end
  
  if found1==0
      lookup_chain.pop()
      return lookup_chain.push("Error: record not found for #{domain}")
  end
end
  
# `domain` contains the domain name we have to look up.
domain = get_command_line_argument
  
# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")
  
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
  