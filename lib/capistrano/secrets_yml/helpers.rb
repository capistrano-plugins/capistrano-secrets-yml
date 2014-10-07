require "yaml"

module Capistrano
  module SecretsYml
    module Helpers

      def local_secrets_yml(env)
        @local_secrets_yml ||= YAML.load_file(secrets_yml_local_path)
        @local_secrets_yml[env]
      end

      def secrets_yml_env
        fetch(:secrets_yml_env).to_s
      end

      def secrets_yml_content
        { secrets_yml_env => local_secrets_yml(secrets_yml_env) }.to_yaml
      end

      # error helpers

      def check_git_tracking_error
        puts
        puts "Error - please remove '#{fetch(:secrets_yml_local_path)}' from git:"
        puts
        puts "    $ git rm --cached #{fetch(:secrets_yml_local_path)}"
        puts
        puts "and gitignore it:"
        puts
        puts "    $ echo '#{fetch(:secrets_yml_local_path)}' >> .gitignore"
        puts
      end

      def check_config_present_error
        puts
        puts "Error - '#{secrets_yml_env}' config not present in '#{fetch(:secrets_yml_local_path)}'."
        puts "Please populate it."
        puts
      end

      def check_secrets_file_exists_error
        puts
        puts "Error - '#{fetch(:secrets_yml_local_path)}' file does not exists, and it's required."
        puts
      end

    end
  end
end

