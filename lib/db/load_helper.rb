require_relative "helper.rb"

module LoadHelper
  def self.import_on_local()
    run_locally do
      execute "mysql #{Helper::mysql_args} < #{fetch(:db_local_dump)}"
    end
  end

  def self.import_on_container(container)
    container.upload!(fetch(:db_local_dump), fetch(:db_remote_dump))

    container.execute("mysql #{Helper::mysql_args} < #{fetch(:db_remote_dump)}")
  end

  def self.import_on_server()
    upload!(fetch(:db_local_dump), fetch(:db_remote_dump))

    execute("mysql #{Helper::mysql_args} < #{fetch(:db_remote_dump)}")
  end
end
