ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(user, session) 
    session[:user_id] = users(user).id
  end 

  def logout 
    session.delete :user_id
  end 

  def login_setup 
    # log in user 
    my_user = users("test_user")
    get '/login'
    post '/login', params: {name: my_user.name, email: my_user.email, password: 'abc'}
    if defined? session 
      login_as :test_user, session
    end 
  end 

  def get_test_user 
    users(:test_user)
  end 
end
