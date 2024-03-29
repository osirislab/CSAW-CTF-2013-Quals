require 'socket'
require 'timeout'
require 'securerandom'

'''
keygenme server for CSAW CTF 2013
Jeffrey Crowell

Users must get 10 correct serials 
within 5 seconds each
'''


server = TCPServer.open(80085)   # Socket to listen on port 2000
loop {                          # Servers run forever
    Thread.start(server.accept) do |client|
    sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
    puts "connection from  #{remote_hostname} #{remote_ip} #{remote_port}"
    client.puts "welcome to the activation server\r\n"        
    (0..9).each{|i|
        user = SecureRandom.urlsafe_base64(16)
        keys = `./keygen #{user}`.strip
        client.puts("give me the password for #{user}")
        begin
            Timeout::timeout(5) do
                pass = client.gets.chomp.strip
                if pass == keys
                    client.puts(":-)")
                else
                    client.puts("wrong password :'-(")
                    client.close
                end
            end
        rescue Timeout::Error
            client.puts("too slow :'-(")
            client.close
        end
    }
    client.puts "here's the flag key{r3vers1ng_emul4t3d_cpuz_a1n7_h4rd!}"
    puts "solve from  #{remote_hostname} #{remote_ip} #{remote_port}"
    client.close                # Disconnect from the client
    end
}
