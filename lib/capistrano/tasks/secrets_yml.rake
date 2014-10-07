include Capistrano::SecretsYml::Paths
include Capistrano::SecretsYml::Helpers

namespace :load do
  task :defaults do
    set :secrets_yml_local_path, "config/secrets.yml"
    set :secrets_yml_remote_path, "config/secrets.yml"
    set :secrets_yml_env, -> { fetch(:rails_env) || fetch(:stage) }
  end
end

namespace :secrets_yml do

  desc "Setup `secrets.yml` file on the server(s)"
  task :setup do
    content = secrets_yml_content
    on release_roles :all do
      execute :mkdir, "-pv", File.dirname(secrets_yml_remote_path)
      upload! StringIO.new(content), secrets_yml_remote_path
    end
  end

  # Update `linked_files` after the deploy starts so that users'
  # `secrets_yml_remote_path` override is respected.
  task :secrets_yml_symlink do
    set :linked_files, fetch(:linked_files, []).push(fetch(:secrets_yml_remote_path))
  end
  after "deploy:started", "secrets_yml:secrets_yml_symlink"

end

desc "Server setup tasks"
task :setup do
  invoke "secrets_yml:setup"
end
