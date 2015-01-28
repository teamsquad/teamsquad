## TeamSquad

![https://codeclimate.com/github/teamsquad/teamsquad](https://codeclimate.com/github/teamsquad/teamsquad.png) ![https://travis-ci.org/teamsquad/teamsquad](https://travis-ci.org/teamsquad/teamsquad.svg?branch=master)

TeamSquad is a website for managing sports leagues, cups, fixtures, results, and some other stuff besides.

http://www.teamsquad.com

![Screenshot 1](http://www.teamsquad.com/images/shot1.png)

### Built with

Ideally you'd just sign up and use the finished site but if you want to run the code yourself (maybe to help improve it) then you need...

* Ruby
* Rails
* Postgres
* Foreman/Puma (or whatever floats your boat)

Runs just fine on Heroku.

### Getting started

    bundle install
    createdb teamsquad_dev
    rake db:migrate
    rake db:seed
    foreman start

To actually do anything you're going to want to login ('test@teamsquad.com' and 'password'). Then you can add fixtures, enter results, and all that jazz.

### Helping

Pull requests welcome. Tests preferred.

### License

MIT.
