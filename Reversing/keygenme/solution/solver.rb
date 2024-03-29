require 'socket'

"""
keygenme solver for CSAW CTF 2013
Jeffrey Crowell
top sekret solution

"""

host = 'raxcity.com'
port = '2000'
socket = TCPSocket.open(host, port)
s = socket.gets.strip
puts "SERVER: #{s}"
(0..9).each{|i|
    s = socket.gets.strip
    puts "SERVER: #{s}"
    m = s.split(" ")
    u = m[-1]
    k = `./keygen #{u}`.strip
    puts "KEYGEN: #{k}"
    socket.puts(k)
    s = socket.gets.strip
    puts "SERVER: #{s}"
}

s = socket.gets.strip
puts "FLAG: #{s}"

