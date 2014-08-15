class WelcomeController < ApplicationController
	def index
	end

    def partial
        render "partial/#{params[:partial_name]}", layout: false
    end
end