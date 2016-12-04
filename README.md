# OLB Marketing

https://olbmarketingdatabase.herokuapp.com

This is the source code to the CSE 5911 capstone project for Our Lady of Bethlehem.

### Instructions on How to Install the Files
Open a terminal and go to the directory you want the project to live.

```
Then you can clone the repository:    $ git clone https://github.com/olbmarketing/olbmarketing.git. 
Since it is a rails app you must run: $ bundle install
                                      $ rails rake db:migrate
This will have the app ready so run:  $ rails s                                      
```
### System Requirements
You must have: 
* git
* postgresql
* ruby
* rails

### Deployment
The Web application is hosted on Heroku.
While in the Master branch, all code must be pushed. 
```
This means that: $ git status                   --should return a message of a clean branch that is up-to-date. 
run:             $ heroku login                 --enter the credentials to Lauren Harrington Heroku account. 
run:             $ git push heroku master       --wait for the push succeed message. 
```
After this, navigate to the website and see your changes. We used the guide on heroku.com to help us and can be found here:
https://devcenter.heroku.com/articles/getting-started-with-rails4

### IDE
The team used a variety of IDEs:
* RubyMine
* Atom
* Sublime
