require 'rubygems'
require 'sinatra'

set :sessions, true


get '/' do
  "Hello World this ti the test"
end

get '/login' do
	# "Please enter your name to start the game."
	erb :temp
end

get '/giselle' do
	redirect '/login'
end

get '/myaction' do
	puts params['username']
	erb :'users/profile'
end



