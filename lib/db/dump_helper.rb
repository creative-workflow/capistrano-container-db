require_relative "helper.rb"

module Capistrano
  module Container
    module DB
      module DumpHelper
        def self.dump_on_local()
          args = Helper::mysql_dump_args

          run_locally do
            execute "mysqldump #{args} > #{fetch(:db_local_dump)}"
          end
        end

        def self.dump_on_server_and_download()
          args = Helper::mysql_dump_args

          on roles(:db, :container_host) do |host|
            execute "mysqldump #{args} > #{fetch(:db_remote_dump)}"

            download!(fetch(:db_remote_dump), fetch(:db_local_dump))
          end
        end

        def self.dump_on_container_and_download(container)
          args = Helper::mysql_dump_args

          container.execute("mysqldump #{args} > #{fetch(:db_remote_dump)}")

          container.download!(fetch(:db_remote_dump), fetch(:db_local_dump))
        end
      end

    end
  end
end
