#!/usr/bin/env ruby


require 'sinatra'

get %r{/build/(.*)} do |req|

	content_type :text
	args = req.split '/'
	project = args.shift
	flags = ''
	unless args.empty?
		args.each do |a|
			flags << "--#{a} "
		end
	end
	command = "pjam -p #{project}  #{flags} 1>pjam-server.log  2>&1"
	st = system(command)
	if st == true
		body File.read("pjam-server.log")
	else
		body File.read("pjam-server.log")
		status 500
	end
				
end

get '/' do
	content_type :text
	`ls -1  2>&1`
end

