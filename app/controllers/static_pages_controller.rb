class StaticPagesController < ApplicationController
	before_action :setup

  def home

  end

  def help
  	
  end

  def about
   	
  end

  private
  def setup
  	@base_title = "Ruby on Rails Tutorial Sample App"
  end
end
