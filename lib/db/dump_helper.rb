require_relative "helper.rb"

module DumpHelper
  def self.dump_on_local()
    args = Helper::mysql_args(['--no-create-db'])

    run_locally do
      execute "mysqldump #{args} > #{fetch(:db_local_dump)}"
    end
  end

  def self.dump_on_server_and_download()
    args = Helper::mysql_args(['--no-create-db'])

    execute "mysqldump #{args} > #{fetch(:db_remote_dump)}"

    download!(fetch(:db_remote_dump), fetch(:db_local_dump))
  end

  def self.dump_on_container_and_download(container)
    args = Helper::mysql_args(['--no-create-db'])

    container.execute("mysqldump #{args} > #{fetch(:db_remote_dump)}")

    container.download!(fetch(:db_remote_dump), fetch(:db_local_dump))
  end
end
