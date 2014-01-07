Railscalc
=========

A simple calculator to show sample Rails code.

Instructions
--------

1. Install the required gems: `bundle`
2. Ensure MongoDB is running on your local machine before starting the rails server. Database indexes can be created with `bundle exec rake db:mongoid:create_indexes`.
3. A runthrough of the calculator can be viewed in the browser by running the test suite: `bundle exec rspec`. Sleep functions have been added to make the tests viewable.
4. Start the server with `bundle exec rails s` and browse to the root to use the calculator. Default is http://0.0.0.0:3000.
