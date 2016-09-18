# OLOB

Add a before_filter to any controller that you want to secure. This will force user's to login before they can see the actions in this controller.

before_filter :authorize

Also make sure to run these before running the rails server:

bundle install
rake db:migrate

https://gist.github.com/thebucknerlife/10090014