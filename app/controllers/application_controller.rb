class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # temporary action for deploying to Heroku
  def hello
    render html: "hello world!"
  end

end
