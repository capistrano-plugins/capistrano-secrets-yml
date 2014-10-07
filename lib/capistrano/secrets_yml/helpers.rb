module Capistrano
  module SecretsYml
    module Helpers

      def read_local_secrets_yml
        @local_secrets_yml ||= YAML.load_file(secrets_yml_local_path)
      end

      def secrets_yml_content
        @content ||= begin
          env = fetch(:secrets_yml_env).to_s
          Hash[env => read_local_secrets_yml.fetch(env)].to_yaml
        end
      end

    end
  end
end

