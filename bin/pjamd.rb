#!/usr/bin/env ruby


require 'sinatra'
require 'sinatra/config_file'

config_file "#{ENV['HOME']}/.pjamd/config.yaml"

set :bind, settings.bind || '0.0.0.0'
set :port, settings.port || '9000'


get %r{/build/(.*)} do |project|
    command = "cd #{settings.root_dir} &&  ~/jam/bin/pjam -p #{project}  2>&1"
    content_type :text
    `#{command}`
end


get '/' do
    command = "cd #{settings.root_dir} &&  ls -1  2>&1"
    content_type :text
    `#{command}`
end