# Aquae

Aquae helps you understand where your water come sfrom and the health of our water systems.

Reservoirs are at the lowest levels we've seen in more than a decade but it's hard to find out what it really means.
Many people don't even know where their water comes from and it's not always easy to find out.

We want to help answer important questions about water in an easy to understand manner.

# Development

## Getting Started

### Requirements

To run the specs or fire up the server, be sure you have these installed:

* Ruby 2.1 (see [.ruby-version](.ruby-version)).
* PostgreSQL 9.x (```brew install postgresql```) with superuser 'postgres' with no password (```createuser -s postgres```).
* PhantomJS for Capybara and Javascript testing (```brew install phantomjs```).

### First Time Setup

After cloning, run these commands to install missing gems and prepare the database.

    $ gem install bundler
    $ bundle
    $ rake db:setup db:sample_data

Note, ```rake db:sample_data``` loads a small set of data for development. Check out [db/sample_data.rb](db/sample_data.rb)
for details.

### Running the Specs

To run all Ruby and Javascript specs.

    $ rake

### Running the Application Locally

    $ foreman start
    $ open http://localhost:3000

## Conventions

### Git

* Branch ```master``` is auto-deployed to production.
* Create feature branches off of ```master``` using the naming convention ```(features|chores|bugs)/a-brief-description-######```, where ###### is the tracker id.
* Rebase your branch before merging into ```master``` to produce clean merge bubbles.
* Retain merge commits for multi-commit branches when merging into ```master``` (e.g. ```git merge --no-ff branchname```).
* Craft atomic commits that make sense on their own and can be easily cherry-picked or reverted if necessary.

### Code Style

Generally speaking, follow the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide). Additionally, these are other guidelines adopted by the team:

**Always use double quotes for test/spec descriptions, unless the subject is a class/module.**

```ruby
describe SomeController do
  context "when logged in as an admin" do
    describe "#some_method" do
      it "does some thing"
    end
  end
end
````

## Additional/Optional Development Details

### Using Guard

Guard is configured to run ruby and jasmine specs, and also listen for livereload connections.

    $ bundle exec guard

### Using Mailcatcher

    $ gem install mailcatcher
    $ mailcatcher
    $ open http://localhost:1080/

Learn more at [mailcatcher.me](http://mailcatcher.me/). And please don't add mailcatcher to the Gemfile.

### Continuous Integration and Deployment with CircleCI

This project is configured for continuous integration and deployment with CircleCI and Heroku.

Check out [circle.yml](circle.yml) and [bin/deploy.sh](bin/deploy.sh) for details.

# Server Environments

### Hosting

Production is hosted on Heroku.

### Environment Variables

Several common features and operational parameters can be set using environment variables.

**Required**

* ```SECRET_KEY_BASE``` - Secret key base for verfying signed cookies. Should be 30+ random characters and secret!

**Optional**

* ```HOSTNAME``` - Canonical hostname for this application. Other incoming requests will be redirected to this hostname.
* ```BASIC_AUTH_PASSWORD``` - Enable basic auth with this password.
* ```BASIC_AUTH_USER``` - Set a basic auth username (not required, password enables basic auth).
* ```PORT``` - Port to listen on (default: 3000).
* ```UNICORN_WORKERS``` - Number of unicorn workers to spawn (default: development 1, otherwise 3).
* ```UNICORN_BACKLOG``` - Depth of unicorn backlog (default: 16).

### Third Party Services

* Heroku for hosting.
* CircleCI for continuous integration and deployment.
* Mapbox for custom mapping.