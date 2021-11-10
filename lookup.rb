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
    dns_raw.delete_if { |dns_raw| dns_raw[line] == "\n" || dns_raw[line]=='#'}              
    str1 = dns_raw[line].delete(",")
    strings = str1.split
    dns1.push(strings)
    line = line +1
  end
  line =0    
  dns_records = {}
  while line< dns1.length      
    dns_records[dns1[line][1]] = {:type=>dns1[line][0],:target=>dns1[line][2]}
    line = line +1
  end    
  return dns_records
end 

def resolve(dns_records, lookup_chain, domain) 

  if (!dns_records[domain])
    lookup_chain.pop
    lookup_chain << "Error: Record not found for "+domain     
   elsif dns_records[domain][:type] == "A"
    lookup_chain.push(dns_records[domain][:target])
   elsif dns_records[domain][:type] == "CNAME"
    lookup_chain.push(dns_records[domain][:target])
    resolve(dns_records, lookup_chain, dns_records[domain][:target])      
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
  