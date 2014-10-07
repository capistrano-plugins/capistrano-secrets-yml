include Capistrano::SecretsYml::Paths
include Capistrano::SecretsYml::Helpers
namespace :load do task :defaults do
    set :secrets_yml_local_path, "config/secrets.yml"
    set :secrets_yml_remote_path, "config/secrets.yml"
    set :secrets_yml_env, -> { fetch(:rails_env) || fetch(:stage) }
  end
end

namespace :secrets_yml do

  task :check_secrets_file_exists do
    next if File.exists?(secrets_yml_local_path)
    check_secrets_file_exists_error
    exit 1
  end

  task :check_git_tracking do
    next unless system("git ls-files #{fetch(:secrets_yml_local_path)} --error-unmatch >/dev/null 2>&1")
    check_git_tracking_error
    exit 1
  end

  task :check_config_present do
    next unless local_secrets_yml(secrets_yml_env).nil?
    check_config_present_error
    exit 1
  end

  desc "secrets.yml file checks"
  task :check do
    invoke "secrets_yml:check_secrets_file_exists"
    invoke "secrets_yml:check_git_tracking"
    invoke "secrets_yml:check_config_present"
  end

  desc "Setup `secrets.yml` file on the server(s)"
  task setup: [:check] do
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
