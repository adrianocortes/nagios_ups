
require 'snmp'
include SNMP


DEFAULT_WARN = 20
DEFAULT_CRITICAL = 15

CRITICAL_MESSAGE = "Battery CRITICAL"
WARN_MESSAGE = "Battery WARNING"



def show_usage( message = '' )
  puts ""
  puts "#{message}" unless message == ""
  puts "" unless message == ""
  
  puts "SNMP UPS Monitor for use in Nagios or similar."
  puts "  This plugin return Battery autonomy, working in Battery ou no."

  puts "    usage:"
  puts "         #{$0} <-help> -H <host_address> [-P port] [-C community] -w <wv> -c <cv> "
  puts ""
  puts "    OPTIONS:"
  puts "            -help Show this Help text"
  puts "            -H Host address to be monitored"
  puts "            -C Community key - Default: 'public'"
  puts "            -P Port for SNMP connection"
  puts "            -c <cv>     cv - value to start CRITICAL alert - Default #{DEFAULT_CRITICAL} minutes"
  puts "            -w <wv>     wv - value to start WARN alert - Default #{DEFAULT_WARN} minutes"
  puts ""
  puts ""


  exit
end



begin

    #Verify params and format

    # IF Help
    param_help_index = ARGV.index('-help')
    show_usage unless param_help_index.nil?

    unless param_host_index.nil?
      show_usage() if param_host.nil?
    end


    # Host Params
    param_host_index = ARGV.index('-H')
    param_host = ARGV[param_host_index + 1] unless param_host_index.nil?

    unless param_host_index.nil?
      show_usage() if param_host.nil?
    end


    #Port Params
    param_port_index = ARGV.index('-P')
    param_port = ARGV[param_port_index + 1] unless param_port_index.nil?

    unless param_port_index.nil?
      show_usage if param_port.to_i.nil?
    end


    #Community params
    param_communit_index = ARGV.index('-C')
    param_communit = ARGV[param_communit_index + 1] unless param_communit_index.nil?

    unless param_communit_index.nil?
      show_usage if param_communit.nil?
    end

    #Critical Alert
    param_critical_index = ARGV.index('-c')
    param_critical = ARGV[param_critical_index + 1].to_i unless param_critical_index.nil?

    unless param_critical_index.nil?
      show_usage if param_critical.to_i.nil?
      
    end
    
    #WarnAlert
    param_warn_index = ARGV.index('-w')
    param_warn = ARGV[param_warn_index + 1].to_i unless param_warn_index.nil?

    unless param_warn_index.nil?
      show_usage if param_warn.to_i.nil?
      
    end
    

    

    ##Setting default if not used
    param_port ||= 161
    param_communit ||= "public"
    param_critical ||= DEFAULT_CRITICAL
    param_warn ||= DEFAULT_WARN

    
    OIDS_AUTONOMIA_MINUTOS = "1.3.6.1.2.1.33.1.2.3"

    value = nil
    SNMP::Manager.open(:Host => "#{param_host}", :Port => param_port, :community => param_communit) do |manager|
        ifTable = ObjectId.new(OIDS_AUTONOMIA_MINUTOS)
        response = manager.get_next(ifTable)
        varbind = response.varbind_list.first
        value = varbind.value.to_i
    end
    
    

    
rescue Exception => e
  show_usage
end


if value <= param_critical
  puts "#{CRITICAL_MESSAGE} - #{(value)} minute(s) remainig!"
  exit 2
elsif value <= param_warn
  puts "#{WARN_MESSAGE} - #{(value)} minute(s) remainig!"
  exit 1
end  
  
