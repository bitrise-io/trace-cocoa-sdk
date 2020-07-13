require 'netrc'

# Read netric for Cocoapods netrc details
netrc = Netrc.read
username, password = netrc["trunk.cocoapods.org"]

print "Details for tunk.cocoapods.org: \n"
print "username: #{username} \n"
print "password: #{password} \n"
