#!/usr/bin/env ruby

require 'socket'
require 'getoptlong'

hostname = Socket.gethostname

opts = GetoptLong.new(
        [ '--help'   , '-h' , GetoptLong::NO_ARGUMENT ]       ,
        [ '--vip'    , '-v' , GetoptLong::REQUIRED_ARGUMENT ] ,
        [ '--master' , '-m' , GetoptLong::REQUIRED_ARGUMENT ] ,
        [ '--slave'  , '-s' , GetoptLong::REQUIRED_ARGUMENT ] ,
)

def usage
        puts <<-EOF

Usage: check_nx_vip -v <vip> -m <hostname> -s <hostname>

-h, --help:
   show help

-v, --vip:
   Set limit for warning

-m, --master
   Set master hostname or ip address

-s, --slave
   Set slave hostname or ip address

        EOF
end

opts.each do |opt, arg|
        case opt
        when '--help'
                usage
        when '--vip'
                @vip = arg
        when '--master'
                @master = arg
        when '--slave'
                @slave = arg
        end

end

if Socket.ip_address_list.to_s.match("#{@vip}")
        if hostname == @master
                puts "OK: VIP up on master"
                exit 0
        end
        else
        if hostname == @slave
                puts "OK: VIP down on slave"
                exit 0
        end
end

if @vip.nil? or @master.nil? or @slave.nil?
        puts "ERROR: Missing commandline arguments"
        exit 0
end

puts "WARNING: Slave Host #{@slave} has the VIP"
exit 1
