require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

before do #evaluated before each request
	# binding.pry
end

get '/' do
  if session[:username] == nil  	
	  redirect '/login'
	else
		erb :start
  end
end

get '/end_game' do
	# redirect '/game_over'
	erb :game_over
end

get '/start_over' do
	session[:username] = nil
	redirect '/'
end

get '/login' do
	# "Please enter your name to start the game."
	# session[:username] = nil
	erb :login
end

get '/game' do	
	if session[:win] == 1
		@success = "#{session[:username]} win ! You got #{session[:bet_money]}."
	elsif session[:win] == 2
		@error = "#{session[:username]} lose! You loss #{session[:bet_money]}"
	elsif session[:win] == 3		
		@warnning = "Even!"
	end
	erb :game
end

get '/new_game' do
	cards_initial
	redirect '/game'
	# redirect '/'
end

post '/myaction' do
	if params[:username].empty?
		@error = "Name shoud't be empty!"
		halt erb e:login
		# halt redirect '/login'
	end	
	# binding.pry
	session[:money] = 500
	session[:username] = params[:username]
	# binding.pry
	redirect '/'
end

post '/bet_action' do
	if params[:bet_money].to_i <= session[:money]
		session[:bet_money] = params[:bet_money].to_i
		
		# erb :game
		redirect '/new_game'
	else
		@error = "Your bet cannot larger than #{session[:money]}"
		erb :start
	end
end

post '/game/dealer_hit' do
	while session[:dealer_total] < 17
		session[:dealer_cards] << session[:cards].pop
		session[:dealer_total] = count_card(session[:dealer_cards])
	end

	session[:dealer_turn] = false

	if session[:dealer_total] == 21
		session[:win] = 2
		session[:money] -= session[:bet_money]
	elsif session[:dealer_total] > 21
		session[:win] = 1
		session[:money] += session[:bet_money]
	else
		if session[:dealer_total] > session[:player_total]
			session[:win] = 2
			session[:money] -= session[:bet_money]
		elsif session[:dealer_total] < session[:player_total]
			session[:win] = 1
			session[:money] += session[:bet_money]
		else
			session[:win] = 3
		end	
	end

	# erb :game
	redirect '/game'
end

post '/game/hit' do
	session[:player_cards] << session[:cards].pop

	#計算結果
	session[:player_total] = count_card(session[:player_cards])
	if session[:player_total] > 21
		session[:win] = 2
		session[:player_turn] = false
		session[:money] -= session[:bet_money]
		@error = 'You busted'
	elsif session[:player_total] == 21
		session[:win] = 1
		session[:player_turn] = false
		session[:money] += session[:bet_money]
		@success = 'You win'
	end		
	# binding.pry
	# if blackjack or busted 
	# end player turn start with dealer turn

	# erb :game
	redirect '/game'
end

post '/game/stay' do
	session[:win] = 0
	session[:player_turn] = false
	session[:dealer_turn] = true

	redirect '/game'
end

helpers do

	def cards_initial
		session[:cards] = []
		# suits = ['spades','hearts','diamonds','clubs']
		suits = ['S','H','D','C']
		values = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
		session[:cards] = suits.product(values).shuffle!
		# binding.pry

		session[:dealer_cards] = []
		session[:player_cards] = []

		session[:dealer_cards] << session[:cards].pop
		session[:dealer_cards] << session[:cards].pop

		session[:player_cards] << session[:cards].pop
		session[:player_cards] << session[:cards].pop

		session[:player_turn] = true
		session[:dealer_turn] = false
		session[:win] = 0 #0:no one 1:player 2:dealer

		session[:player_total] = count_card(session[:player_cards])
		session[:dealer_total] = count_card(session[:dealer_cards])
	end

	def count_card(cards)
	  total = 0

	  cards.each do |p|
	  	c = p[1]
	    case c   
	    when "J","Q","K"
	      total += 10
	    when "A"
	    	total += 1
	    else
	      total += c.to_i
	    end
	  	# binding.pry
	  end

	  # have_A.times do
	  cards.select{|c| c == "A"}.count.times do
	    if total <= 11
	    	total += 10    	
	    end
	  end

	  total
	end

	def show_card_image(card)
		suit = ''
		value = ''
		case card[0]
		when 'C'
			suit = 'clubs'
		when 'D'
			suit = 'diamonds'
		when 'H'
			suit = 'hearts'
		when 'S'
			suit = 'spades'
		end

		case card[1]
		when 'A'
			value = 'ace'
		when 'J'
			value = 'jack'
		when 'Q'
			value = 'queen'
		when 'K'
			value = 'king'
		else
			value = card[1].to_s
		end

		# 'images/cards/' + suit + '_' + value + '.jpg'
		"/images/cards/#{suit}_#{value}.jpg"
	end

end
	

