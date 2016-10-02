# OLOB
Add a before_filter to any controller that you want to secure. This will force user's to login before they can see the actions in this controller.

before_filter :authorize

Also make sure to run these before running the rails server:

bundle install

rake db:migrate

Here is the tutorial I used:
https://gist.github.com/thebucknerlife/10090014

Also, I think I added a account to the app:
Name: admin1
email: admin1@admin1.com
password: admin1

ALL THIS IS OLD AND SHOULD NOT BE USED!!!
This was with Heroku and didn't work.
We need to be able to deploy somewhere and I just went with Heroku since it is "easy" to do that. Here is the installer:

https://devcenter.heroku.com/articles/heroku-command-line

We have to add postgresql for our deploys since it look like most servers do not work well with SQLite(including Heroku). If you run bundle install and get a error you must first install the postresql library. This is how to solve it on a mac, I don't know about Linux.

brew install postgresql

Note: If there is migration error saying that the star_tests table already exists. 
the following method can be used. 
Note that the next command will delete everything in the db and reset db. Therefore, there will be only empty database after the following command. Even existing user account will be deleted. 
bundle exec rake db:migrate:reset
Now when you go to http://localhost:3000/login you will get an error saying that user cannot be found. 
now temporarily update the application_controller.rb
comment out line 7 @current_user
add @current_user = nil to the next line, save 
Now go to http://localhost:3000/ sign up for a user. 
reverse application_controller.rb back to where it was. save
go to http://localhost:3000/login to login again. 