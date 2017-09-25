require 'sinatra/base'
require './models/deskpro'
require 'staccato'

# App is the main Sinatra application
class App < Sinatra::Base

	get '/' do
		erb :index
	end

	get '/register' do
		@ticket = Deskpro::Ticket.new
		erb :register
	end

	post '/register' do
		@ticket = Deskpro::Ticket.new({
			subject: "#{Date.today.to_s} New user registration",
			message: "#{params['person_name']} would like to request an account",
			person_email: params['person_email'],
			person_name: params['person_name'],
			label: ['paas', 'signup'],
		})
		@ticket.agent_team_id = ENV['DESKPRO_TEAM_ID'].to_i if ENV['DESKPRO_TEAM_ID']
		if not @ticket.valid?
			status 400
			erb :register
		else
			deskpro.post @ticket
			track_event 'register'
			erb :thanks
		end
	end

	get '/support' do
		@ticket = Deskpro::Ticket.new
		erb :support
	end

	post '/support' do
		@ticket = Deskpro::Ticket.new({
			subject: "#{Date.today.to_s} Support Request From Website",
			person_email: params['person_email'],
			person_name: params['person_name'],
			message: params['message'],
			label: ['paas', 'enquiry'],
		})
		@ticket.agent_team_id = ENV['DESKPRO_TEAM_ID'].to_i if ENV['DESKPRO_TEAM_ID']
		if not @ticket.valid?
			status 400
			erb :support
		else
			deskpro.post @ticket
			track_event 'enquire'
			erb :thanks
		end
	end

	not_found do
		erb :not_found
	end

	error do
		@error = env['sinatra.error']
		erb :error
	end

	helpers do

		# return comma seperated list of errors from validation if resourse has been validated
		def errors_for(resource, field)
			return nil if !resource.validated?
			errs = resource.errors[field]
			return nil if !errs or errs.size == 0
			return errs.join(", ")
		end

		# create a deskpro client
		def deskpro
			Deskpro::Client.new(
				api_key: ENV['DESKPRO_API_KEY'],
				endpoint: ENV['DESKPRO_ENDPOINT']
			)
		end

		# if google analytics tracking ids available send tracking event
		def track_event(action)
			if params['ga_tracking_id'] and params['ga_client_id']
				tracker = Staccato.tracker(params['ga_tracking_id'], params['ga_client_id'], ssl: true, document_hostname: params['ga_hostname'])
				tracker.event(category: 'support', action: action, value: 1)
			end
		end

	end

end
