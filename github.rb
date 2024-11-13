#!/usr/bin/ruby

# github.rb 

require 'octokit'

DEBUG = false

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
	if DEBUG
		print "SurfEasy members include: "
		members.each { |member|
			print " #{member.login}"
		}
		print "\n"
		STDOUT.flush
	end

	# repos - both public & private
	repos = client.organization_repositories( company.login, :type => 'all')
	if DEBUG
		print "SurfEasy repos include: "
		repos.each { |repo|
			print " #{repo.name}"
		}
		print "\n"
		STDOUT.flush
	end


	# activity for the last week
	last_week = 7.days.ago
	today = Time.now

		# pre team member
	#events - type = push
	members.each { |member|

#TODO - will get the 1st 30 events, use option 'page' to get next set if required
		events = client.organization_events( company.login)
#		events = client.user_events( member.login)

		# this will print the most recent 30 events for the team

# TODO
#  have one various that prints last 24 hours of events
#  have another that does it just for a developer

		if (events.count > 0)
			puts "#{company.login} team worked on:"
			events.each { |event|
				event_date = Time.parse( event.created_at)
				# if in last 7 days, 
				if (event_date > last_week) 
					if (event.type == "PushEvent")
						puts "  #{event.actor.login} pushed to #{event.repo.name} on #{event.created_at}" 
					else 
						puts " #{event.actor.login} - #{event.type}  #{event.keys}"
					end
				end
			}
		end

	}
		# commits for last week
end

exit


