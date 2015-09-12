class ApiController < ApplicationController
  	before_action :set_shortcut, only: [:show]

	def show
		redirect_to @shortcut.url
	end

private
    def set_shortcut
    	@shortcut = Shortcut.with_normalized_target(params[:target]).first
    	raise ActiveRecord::RecordNotFound.new("No Shortcut found with target='#{params[:target]}'") unless @shortcut
    end

end