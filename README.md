# DiscoverIt

## Description:
* A Ruby on Rails application for creating user posts. Similar to Reddit.


## User Guideline:
* Go to [DiscoverIt](https://warm-wildwood-27346.herokuapp.com/)
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

# Building The App's Features: A summary

#### Initial Steps
First, I started by creating a new rails app `rails new <discoverit> -T`specifying that I would like to build an app without the standard test package since I would be adding Rspec to my application. I then populated the gemfile with all the gems needed, ran `bundle install` and finally `rails db:create` to create our databases for the development environment. I started the Puma server `rails s` and ran the app through localhost:3000.

#### Static Pages
Next I generate the controller and views for the welcome page `rails generate controller welcome index about` and configure the routing in config/routes.rb.

    Rails.application.routes.draw do
      get "welcome/index"

      get "welcome/about"

      root 'welcome#index'
    end

By specifying ‘root’ above, we specify the default page when the app loads.

#### Testing with Rspec

Test code states the expectation when production code is executed. This is where the Rspec library comes in. Rspec will raise errors when the expectation stated are not met by production code. Testing is crucial to any application, as it helps to catch bugs early on.
Adding Rspec to the gemfile: 

     group :development, :test do
       gem 'rspec-rails', '~> 3.0'
       gem 'rails-controller-testing'
     end

As with every update to the gemfile, I ran `bundle` to update the application with the Rspec installation and used Rspec generator to configure the app for testing. From now onward, anytime I generated a model or controller, Rspec automatically created test files for them.

#### HTML and CSS

Next, I incorporated HTML, CSS, Bootstrap and SASS into the application for basic styling. Since I was looking to put styling on the whole app, I placed my code in the application.scss file. Styling individual pages will come later on when I have more pages in the app.

#### Models

For users to have the ability to submit posts with titles and descriptions, I generated the Post model with two attributes `rails generate model Post title:string body:text`. Next, I generated the Comment model to handle users post comments. `$ rails generate model Comment body:text post:references`. The comments model has a references attribute which gives a reference to the post model; giving the comment an id that uniquely identifies each comment with the posts model. The references attribute creates a foreign key post_id in the comments table and creates the association required between the post and comments.

#### Relational Mapping: Active Record

A model is a Ruby class that must be represented as a database table. Rails must be able to communicate with the database. The rails framework speaks ruby, while the database speaks SQL. This could raise complexity in getting the two to communicate. 

Luckily, there’s Active Record, which is an ORM library that helps to translate the language between the two systems. This translation/communication can be done through the rails console. The rails console is launched using `rails c`. It loads the application in a shell and provides access to the application code. Meaning, I can create posts and comments within the console, from the command line `Post.create(title: "Sample Post", body: "This is a sample post")`.

#### Seeding Test Data 

Next, I populated the application with test data so I could test to see if the application behaves as intended. Test data allowed me  to easily spot bugs.

Here I added a chunk of code to db/seeds.rb:

    require 'random_data'

     # Creating Posts
     50.times do
       Post.create!(
         title:  RandomData.random_sentence,
         body:   RandomData.random_paragraph
       )
     end
     posts = Post.all

     # Creating Comments
     100.times do
       Comment.create!(
         post: posts.sample,
         body: RandomData.random_paragraph
       )
     end

     puts "Seed finished"
     puts "#{Post.count} posts created"
     puts "#{Comment.count} comments created"


#### CRUD

From here on, I started building out the rest of the application’s resources, consisting of models, views and controllers. I had already created the post and comments model previously. Here, I generated the Post controller and views `$ rails generate controller Posts index show new edit `.

In the route.rb file, refactor the method calls with `resources :posts`

I also implemented CRUD. CRUD stands for Create Read Update Delete. CRUD actions/functionalities align with HTTP verbs and controller actions POST,  GET, PUT/PATCH, DELETE respectively.


#### Validations

Adding validations to the application would ensure that users don’t post empty posts or comments. If a field does not meet the set validation, the user will get an error telling them the exact reason why the submission was rejected.

   validates :title, length: { minimum: 5 }, presence: true
   validates :body, length: { minimum: 20 }, presence: true
   validates :topic, presence: true


#### Authentication

Next, I created the User model since I needed a user to be able to implement the authentication feature `$ rails generate model User name:string email:string password_digest:string`

I also incorporate bcrypt at this stage for password encryption.

    Gemfile
     gem 'bcrypt'

#### Authorization

To implement the authorization feature, there had to be roles for different users.

The main roles were;

     Admin User - can create, update or delete any topic or post
     
     Member User - can create, update or delete only their own posts
     
     Guest User - can read anything on the site, but cannot post until they sign up as a member
     
After setting out the roles, I had to place in methods to restrict users depending on whether they were signed in or not and whether their roles allowed for creating, updating and deleting of posts and topics.

    before_action :require_sign_in, except: [:index, :show]

    before_action :authorize_user, except: [:index, :show]
    
      def authorize_user
       unless current_user.admin?
         flash[:alert] = "You must be an admin to do that."
         redirect_to topics_path
       end
     end

#### Comments

Like posts, comments should have a user. Here, I associated comments with users by generating a new migration to add a user_id foreign key to the comments table:`rails generate migration AddUserToComments user:references`
Then I updated the User and Comments models. 

    User.rb
    `user.rb has_many :comments, dependent: :destroy`

    Comments.rb
    `comments.rb: belongs_to :user`
    
I, then create validations for the comments 
 
     validates :body, length: { minimum: 5 }, presence: true
     validates :user, presence: true

In routes.rb, I nested the comments route under posts

    resources :posts, only: [] do
         resources :comments, only: [:create, :destroy]

I generated a comments controller to specify the CRUD methods for user comments as well as setting up authentication.

      before_action :require_sign_in

         def create

           @post = Post.find(params[:post_id])
           comment = @post.comments.new(comment_params)
           comment.user = current_user

           if comment.save
             flash[:notice] = "Comment saved successfully."

             redirect_to [@post.topic, @post]
           else
             flash[:alert] = "Comment failed to save."

             redirect_to [@post.topic, @post]
           end
         end

         private
         
         def comment_params
           params.require(:comment).permit(:body)
         end
         
I used require_sign_in to ensure that guest users are not permitted to create comments. I also set up an `authorize_user` method for the delete function so that only the comment ower and admin can delete the comment.

    before_action :authorize_user, only: [:destroy]

     def destroy
         @post = Post.find(params[:post_id])
         comment = @post.comments.find(params[:id])

         if comment.destroy
           flash[:notice] = "Comment was deleted."
           redirect_to [@post.topic, @post]
         else
           flash[:alert] = "Comment couldn't be deleted. Try again."
           redirect_to [@post.topic, @post]
         end
      end

      def authorize_user
         comment = Comment.find(params[:id])
         unless current_user == comment.user || current_user.admin?
           flash[:alert] = "You do not have permission to delete a comment."
           redirect_to [comment.post.topic, comment.post]
         end
      end  
      
#### Voting 

Here I introduced the upvote and down votes on posts.

To begin, I created the vote model: `rails g model Vote value:integer user:references:index post:references:index`

and included a inclusion validation in the Votes model to ensure that the value of a vote is either 1 or -1 

`validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }, presence: true`

Updated post and votes association in post.rb;
  `has_many :votes, dependent: :destroy`

Then implement up_votes, down_votes and points in posts.rb

     def up_votes
       votes.where(value: 1).count
     end

     def down_votes
       votes.where(value: -1).count
     end

     def points
       votes.sum(:value)
     end
     
Finally, I updated the post views to display the upvote and downvote functionalities.

#### Favorites

The Favorites feature was added so that users can  favorite posts they like. I generate a model for Favorites `rails generate model favorite user:references:index post:references:index`; associated posts with favorites by adding `has_many :favorites, dependent: :destroy` to the post and user models, then generated the favorites controller to handle the creating and removal methods, updated the `routes.rb` and finally updated the views to render the favorite button.

#### Public Profiles

Public profiles is used to show users information about the number of posts, comments and favourites, and for general account information. 

I added factory girl gem which allows its users to build objects they can use for testing. Factories allow for modification of the behavior of a given object type in a single place. I also used gravatar to allow users to personalize their profiles.
