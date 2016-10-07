require_relative "helper.rb"
require 'capistrano/container'

module LoadHelper
  def self.import_on_local()
    LoadHelper.create_db_if_not_exists fetch(:db_name)

    run_locally do
      execute "mysql #{Helper::mysql_restore_args} < #{fetch(:db_local_dump)}"
    end
  end

  def self.import_on_container(container)
    container.upload!(fetch(:db_local_dump), fetch(:db_remote_dump))

    LoadHelper.create_db_if_not_exists fetch(:db_name)

    container.execute "mysql #{Helper::mysql_restore_args} < #{fetch(:db_remote_dump)}"
  end

  def self.import_on_server()
    upload!(fetch(:db_local_dump), fetch(:db_remote_dump))

    LoadHelper.create_db_if_not_exists fetch(:db_name)

    execute("mysql #{Helper::mysql_restore_args} < #{fetch(:db_remote_dump)}")
  end

  def self.create_db_if_not_exists(db)
    Helper.execute_db_command_autodetect "CREATE DATABASE IF NOT EXISTS #{db};"
  end
end
