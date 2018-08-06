# Bloccit

## Description:
* A Reddit replica to teach the fundamentals of web development and Rails.


## User Guideline:
* Go to [Bloccit](https://warm-wildwood-27346.herokuapp.com/)
* Sign in or Sign up for an account
* Create topics and posts 
* Add comments to posts
* Up-vote or down-vote on posts
* Favorite posts and receive notifications for updates to favorited posts
* View a summary of user contributions on the user profile page


## Setup and Configuration:

### Languages and Frameworks:
* Ruby 2.5.0
* Rails 5.2.0
* HTML
* Bootstrap / SASS

### Databases:
* SQLite3 in Test and Development
* PostgreSQL in Production

### Development Tools and Gems include:
* Brypt for encrypting passwords
* Figaro for safely storing sensitive information
* Sendgrid for automated email delivery

### Testing Tools and Gems include:
* Rspec-Rails as a testing framework
* Shoulda for writing understandable, maintianable tests

## Running the application locally:
* Clone or download the repository
* Run bundle install
* Create and migrate the database with `rails db:create` and `rails db:migrate`
* Start Puma (rails server) using `rails s`
* Run the application through localhost:3000



Created by Lucy Njuguna with :heart: at [Bloc.io](http://bloc.io).
