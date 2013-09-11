#!/usr/bin/env ruby


require 'sinatra'
require 'sinatra/config_file'

config_file "#{ENV['HOME']}/.pjamd/config.yaml"

set :bind, settings.bind || '0.0.0.0'
set :port, settings.port || '80'
set :root, settings.base_dir


get %r{/build/(.*)} do |project|
	command = "cd #{settings.base_dir} &&  ~/jam/bin/pjam -p #{project}  1>#{settings.base_dir}/logs/pjamd.log  2>&1"
	content_type :text
	st = system(command)
	if st == true
		body File.read("#{settings.base_dir}/logs/pjamd.log")
	else
		body File.read("#{settings.base_dir}/logs/pjamd.log")
		status 500
	end
				
end

get '/' do
	command = "cd #{settings.base_dir} &&  ls -1  2>&1"
	content_type :text
	`#{command}`
end
