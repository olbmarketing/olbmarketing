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
