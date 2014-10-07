require "pathname"

module Capistrano
  module SecretsYml
    module Paths

      def secrets_yml_local_path
        Pathname.new fetch(:secrets_yml_local_path)
      end

      def secrets_yml_remote_path
        shared_path.join fetch(:secrets_yml_remote_path)
      end

    end
  end
end
