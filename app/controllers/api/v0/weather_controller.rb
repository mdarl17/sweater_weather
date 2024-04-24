class Api::V0::WeatherController < ApplicationController
	def forecast
		w_facade = WeatherFacade.new(q: params[:q], days: params[:days])
		weather = w_facade.weather

		render json: WeatherSerializer.new(weather)
	end
end