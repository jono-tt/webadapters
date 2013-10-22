# WebAdapter 2

Webadapter is a tool for building json apis by scraping data from web pages :). It helps to solve problems of clients that don't have any api but needs one fast.

# Requirements

Ruby 1.9.2
  Bundler (gem install bundler)
Redis

# Setup

You must configure `config/database.yml`, `config/redis.yml` possibly `config/footprints.yml`. First two are required by the project. You can lookup examples in coresponding example files.

# Running the App

Use `bundle exec rails console` to open console shell and create your user eg. `User.create(:email => example@email.com, :password => "mypass")` and next close the console and run the server.

To run the app type `bundle exec rails s` it will startup webserver on port 3000. Navigate to `http://localhost:3000` and login

# Authors

John Cinnamond
Jakub Oboza

# License

Apache 2.0, attached in LICENSE file.
