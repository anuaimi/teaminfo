#!/usr/bin/ruby

# start.rb 

require 'octokit'

puts "username:"
STDOUT.flush
login = gets.chomp

puts "password:"
STDOUT.flush
password = gets.chomp


# authenticate
client = Octokit::Client.new(:login => login, :password => password)

# get details on user
user = client.user
puts "your github login is #{user.login}"

# find organizationscompany = nil
organizations = client.organizations
if organizations.count > 0
	print "you are a part of: " 
	organizations.each { |org|
		print " #{org.login}"
	}
	print "\n"
	STDOUT.flush

	# only use the 1st org 
	company = organizations[0]

	members = client.org_members(company.login )
	print "SurfEasy members include: "
	members.each { |member|
		print " #{member.login}"
	}
	print "\n"
	STDOUT.flush


	# repos
	repos = Octokit.organization_repositories( company.login)

	# activity for the last week
		# pre team member
		# commits for last week
end

exit


repos.each { |repo|
	p repo.name
}

# user = Octokit.user "athirn"

