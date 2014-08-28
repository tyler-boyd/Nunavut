class WelcomeController < ApplicationController
	def index
	end

  def partial
      render "partial/#{params[:partial_name]}", layout: false
  end

  def asset
    send_file Rails.root.join('public', request.path.gsub('/assets/', ''))
  end
end