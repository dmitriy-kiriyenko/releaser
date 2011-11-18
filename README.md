# Releaser #

Very often we need to monitor versions of application. This gem helps to
do it.

## Installation ##

Add

```ruby
gem 'releaser'
```

to your `Gemfile`.

## Autoreleasing ##

When issuing major release, run `releaser major NEW_CODENAME`. You may omit
the codename if you are not using any. This will tag a commit and push the tag to origin.
You have `--no-push` option not to do the last step. Running it with `-p` will
issue it in "pretend" mode, without actual making changes.

To issue a minor release, you should run `releaser minor`. It has the same options as `major`, except the codename.

To get the current version just type `release`. Try `-v` for more verbosity.

## Capistrano ##

Add

```ruby
require 'releaser/capistrano'
```

to your `config/deploy.rb` file. This will automagically tag your deploy
commits and push it. Also it will write current revision to the file
`CURRENT_VERSION` in your application directory. To get it from
application, issue

```ruby
Releaser::FromFile.new.version("no version")
```

with an optional argument for a default string (default is "development").

See `lib/releaser/capistrano/release_tagging` for more details.
