class StaticPagesController < ApplicationController
  def home
    @title = 'Home | Ruby on Rails Tutorial Sample App'
  end

  def help
    @title = 'Help | Ruby on Rails Tutorial Sample App'
  end
end
