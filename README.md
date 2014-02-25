Sky Omakase
====

# Introduction
[Sky Omakase](http://hack.jaxihjk.me) is an app that giving suggestions about travelling.

It's basically a typical [Omakase style](http://david.heinemeierhansson.com/2012/rails-is-omakase.html) Rails app. Not the best practice for Rails, since it is a product developed in a 5-day the [University of Edinburgh Hackathon](https://comp-soc.com/ilwhack/page/home). A lot anti-pattern code and long methods exist in the repo, but still quite interesting.

If you are searching for the best practice, Gitlabhq or Thoughtbot might be wiser choice. I really like them.

Since it's a solo project, I have not do it in BDD or TDD. I might add some simple testing cases in the near future. It depends though.

# How to makes it work on your local machine.

Suppose you have a rvm & ruby 2.0 installed on your local. [Pow](http://pow.cx/) is also hightly recommanded.

Install mysql, memcached, redis & elastic search on your local machine. Also make sure they are running heathy in processes.

The rest things might be tricky. Here we go.

- Fill the API keys correctly in your ```.env``` file in the root directory of the app. You can use ```.sample.env``` as the example.

- Make sure ```config/database.yml``` is in place.

- ```$ bundle``` to install all required gems.

- ```$ rake db:migrate ``` to migrate the database.

- ```$ rake airline_lookup:import_airport``` to import all the airport information into the database.


- ```$ rake searchkick:reindex:all``` to index things necessary to elastic search.

- Simply ```$ rails s``` should work. If you using pow, then ```$ ln -s ~/.pow/ /PATH/TO/hack```. After that, everytime you boot your laptop. ```http://hack.dev``` will be in place.

## Backend workers

- Suggestion making service: ```$ bundle exec sidekiq -q best_routes```

- Short message service: ```$ bundle exec sidekiq -q sms```

- or just ```foreman start``` to start both of them above.

If it doesn't work, you probably fill the API keys wrong.

It should be safe for work on windows.

Contact me if you have any problems.

# Lisence

Sky Omakase is released under the [MIT License](http://opensource.org/licenses/MIT).