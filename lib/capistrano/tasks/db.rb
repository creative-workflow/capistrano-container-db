require_relative('../../db/helper.rb')
require_relative('../../db/dump_helper.rb')
require_relative('../../db/load_helper.rb')

namespace :db do
  desc "execute a mysql command local, remote or container host"
  task :execute do
    on roles(:db, :container_host) do |host|
      ask(:tmp_cmd, "mysql command")
      Helper.execute_db_command_autodetect fetch(:tmp_cmd)
    end
  end


  desc "export a local, remote or remote container mysql db"
  task :export do
    on roles(:db, :container_host) do |host|
      if fetch(:db_is_container)
        DumpHelper::dump_on_container_and_download container_by_name(fetch(:db_container_name))
      elsif Helper::local_stage?
        DumpHelper::dump_on_local
      else
        DumpHelper::dump_on_server_and_download
      end

      Helper::duplicate_local_dump_to_staged_dump
    end
  end

  desc "import a local, remote or remote container mysql db"
  task :import do
    on roles(:db, :container_host) do
      if fetch(:db_is_container)
        LoadHelper::import_on_container container_by_name(fetch(:db_container_name))
      elsif Helper::local_stage?
        LoadHelper::import_on_local
      else
        LoadHelper::import_on_server
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :db_user, 'root'
    set :db_pass, ''
    set :db_additional_auth_args, []
    set :db_name, ''
    set :db_additional_restore_args, []
    # dont use --database statement, so no use '...' will be generated and we
    # can have different db names local and remote
    set :db_additional_dump_args, ['--no-create-db --lock-tables=false']
    set :db_remote_dump, '/tmp/dump.sql'
    set :db_local_dump, 'config/db/dump.sql'
    set :db_is_container, false
    set :db_container_name, 'db'
    set :local_stage_name, :local
    set :filter_on_import, lambda{ |sql_dump| return sql_dump }
  end
end
