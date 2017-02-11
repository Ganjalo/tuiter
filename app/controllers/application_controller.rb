class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "Tuiter"
    # puts "<p>Ruby version: #{RUBY_VERSION}</p>"
    # puts "<p>Rails version: #{Rails.version}</p>"
  end
end
