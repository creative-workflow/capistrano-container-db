module Helper
  def self.mysql_args(additional_args=[])
    command = " -u #{fetch(:db_user)}"
    command+= " -p#{fetch(:db_pass)}" unless fetch(:db_pass).empty?
    command+= " #{additional_args.join(' ')} "

    # dont use --database statement, so no use '...' will be generated
    command+= " #{fetch(:db_name)}" unless fetch(:db_name).empty?
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

  def execute_local_or_remote(cmd)
    if local_stage?
      run_locally do
        execute cmd
      end
    else
      execute cmd
    end
  end
end
