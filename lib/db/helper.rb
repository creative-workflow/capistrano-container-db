module Capistrano
  module Container
    module DB
      module Helper
        def self.mysql_dump_args
          command = mysql_auth_args
          command+= " #{fetch(:db_additional_dump_args).join(' ')} "
          command+= " #{fetch(:db_name)}" unless fetch(:db_name).empty?
          command
        end

        def self.mysql_restore_args
          command = mysql_auth_args
          command+= " #{fetch(:db_additional_restore_args).join(' ')} "
          command+= " #{fetch(:db_name)}" unless fetch(:db_name).empty?
          command
        end

        def self.mysql_auth_args
          command = " -u #{fetch(:db_user)}"
          command+= " -p#{fetch(:db_pass)}" unless fetch(:db_pass).empty?
          command+= " #{fetch(:db_additional_auth_args).join(' ')} "
          command
        end

        def self.append_stage_to_filename(file_name, stage = 'local')
          splitted  = file_name.split('.')
          extension = splitted.pop
          splitted.push stage, extension
          splitted.join('.')
        end

        def self.duplicate_local_dump_to_staged_dump()
          staged_file = append_stage_to_filename(fetch(:db_local_dump), fetch(:stage))

          FileUtils.cp(fetch(:db_local_dump), staged_file)
        end

        def self.local_stage?
          fetch(:local_stage_name).to_sym == fetch(:stage).to_sym
        end

        def self.execute_db_command_autodetect(cmd)
          cmd = "mysql #{Helper::mysql_auth_args} -e \"#{cmd}\""

          if fetch(:db_is_container)
            db_container = container_by_name fetch(:db_container_name)
            on_container db_container do |container|
              container.execute cmd
            end
          else
            execute_local_or_remote cmd
          end
        end
      end

    end
  end
end
