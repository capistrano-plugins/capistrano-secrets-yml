# Capistrano::SecretsYml

Capistrano tasks for handling `secrets.yml` when deploying Rails 4+ apps.

### Install

Add this to `Gemfile`:

    group :development do
      gem 'capistrano', '~> 3.2.1'
      gem 'capistrano-secrets-yml', '~> 1.0.0'
    end

And then:

    $ bundle install

### Setup and usage

- make sure your local `config/secrets.yml` is not git tracked. It **should be on
  the disk**, but gitignored.

- populate production secrets in local `config/secrets.yml`:

        production:
          secret_key_base: d6ced...

- add to `Capfile`:

        require 'capistrano/secrets_yml'

- create `secrets.yml` file on the remote server by executing this task:

        $ bundle exec cap production setup

You can now proceed with other deployment tasks.

#### What if a new config is added to secrets file?

- add it to local `config/secrets.yml`:

        production:
          secret_key_base: d6ced...
          foobar: some_other_secret

- if you're working in a team where other people have the deploy rights, compare
  you local `secrets.yml` with the one on the server. This is to ensure you
  didn't miss an update.
- copy to the server:

        $ bundle exec cap production setup

- notify your colleagues that have the deploy rights that the remote
  `secrets.yml` has been updated so they can change their copy.


### How it works

When you execute `$ bundle exec production setup`:

- secrets from your local `secrets.yml` are copied to the server.<br/>
- only "stage" secrets are copied: if you are deploying to `production`,
  only production secrets are copied there
- on the server secrets file is located  in `#{shared_path}/config/secrets.yml`

On deployment:

- secrets file is automatically symlinked to `#{current_path}/config/secrets.yml`

### Configuration

None.

### More Capistrano automation?

Check out [capistrano-plugins](https://github.com/capistrano-plugins) github org.

### FAQ

- shouldn't we be keeping configuration in environment variables as per
  [12 factor app rules](http://12factor.net/config)?

  On Heroku, yes.<br/>
  With Capistrano, those env vars still have to be written somewhere on the disk
  and used with a tool like [dotenv](https://github.com/bkeepers/dotenv).

  Since we have to keep configuration on the disk anyway, it probably makes
  sense to use Rails 4 built-in `secrets.yml` mechanism.

### License

[MIT](LICENSE.md)
