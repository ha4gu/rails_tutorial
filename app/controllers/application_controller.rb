class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # use helpers of Session on whole controllers
  include SessionsHelper

  # temporary action for deploying to Heroku
  def hello
    render html: "hello world!"
  end

end
