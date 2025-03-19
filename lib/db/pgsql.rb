require 'pg'

class Pgsql
  # setup connection db
  def initialize(db_url)
    begin
      @connection = PG::Connection.new( db_url )

      db_setup
    rescue PG::Error => err
      puts "Pgsql database error connection : #{err.message}"
      @connection.reset
    end
  end

  # create type and table
  def db_setup
    # 1. type setup = create or exist type in db
    # value as
    type_setup('value_as', "('STRING', 'INTEGER', 'FLOAT', 'BOOLEAN')")

    # gender
    type_setup('gender', "('MALE', 'FEMALE')")

    # schedule time
    type_setup('schedule_time', "('1 AM', '2 AM', '3 AM', '4 AM', '5 AM', '6 AM', '7 AM', '8 AM', '9 AM', '10 AM', '11 AM', '12 AM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM', '10 PM', '11 PM', '12 PM')")

    # schedule type
    type_setup('schedule_type', "('WEEKLY', 'DAILY')")

    # day name
    type_setup('day_name', "('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY')")

    # 2. table setup = create or exist table in db
    # configs
    table_setup('configs', "(
      id uuid DEFAULT gen_random_uuid(),
      key varchar(200) NOT NULL,
      value varchar(200) NOT NULL,
      value_as value_as,
      PRIMARY KEY (id),
      constraint unique_key unique (key)
    )")

    # subjects
    table_setup('subjects', "(
      id uuid DEFAULT gen_random_uuid(),
      name varchar(100) NOT NULL,
      phone_number varchar(50) NOT NULL,
      gender gender,
      terminate_date DATE,
      PRIMARY KEY (id)
    )")

    # schedules
    table_setup('schedules', "(
      id uuid DEFAULT gen_random_uuid(),
      day day_name,
      start_schedule schedule_time,
      end_schedule schedule_time,
      time_zone varchar(100) NOT NULL,
      inactive_date DATE,
      PRIMARY KEY (id)
    )")

    # announcements
    table_setup('announcements', "(
      id uuid DEFAULT gen_random_uuid(),
      message varchar(200) NOT NULL,
      schedule_id uuid,
      constraint fk_announcement_schedule foreign key (schedule_id) references schedules(id),
      PRIMARY KEY (id)
    )")

    # subject schedules
    table_setup('subject_schedules', "(
      booking_date DATE NOT NULL,
      type schedule_type,
      schedule_id uuid,
      subject_id uuid,
      constraint fk_subject_schedule_schedule foreign key (schedule_id) references schedules(id),
      constraint fk_subject_schedule_subject foreign key (subject_id) references subjects(id),
      PRIMARY KEY (schedule_id, subject_id)
    )")

    # subject cancel schedules
    table_setup('subject_cancel_schedules', "(
      cancel_booking_date DATE NOT NULL,
      reason varchar(200) NOT NULL,
      schedule_id uuid,
      subject_id uuid,
      constraint fk_subject_schedule_schedule foreign key (schedule_id) references schedules(id),
      constraint fk_subject_schedule_subject foreign key (subject_id) references subjects(id),
      PRIMARY KEY (schedule_id, subject_id)
    )")
  end

  # insert config data
  def config_seed(subject_name, limit_schedule, timezone)
    # config 1
    insert_data('configs', "(key, value, value_as)", "('subject_name', '#{subject_name}', 'STRING')")
    # config 2
    insert_data('configs', "(key, value, value_as)", "('limit_schedule', '#{limit_schedule}', 'INTEGER')")
    # config 3
    insert_data('configs', "(key, value, value_as)", "('timezone', '#{timezone}', 'STRING')")
  end

  private
    def type_setup(name, values)
      pgsql_exec("DO $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = '#{name}') THEN
                create type #{name} AS ENUM #{values};
            END IF;
        END
      $$;")
    end

    def table_setup(name, values)
      pgsql_exec("CREATE TABLE IF NOT EXISTS #{name} #{values}")
    end

    def insert_data(selection_table, keys, values)
      pgsql_exec("INSERT INTO #{selection_table}#{keys} VALUES #{values};")
    end

    def pgsql_exec(query)
      @connection.exec(query) do |result|
        puts "STATUS : #{result.res_status}"
        puts "SUCCESS MESSAGE : #{result.result_status}"
        puts "ERROR MESSAGE : #{result.result_error_message}"
      end
    end
end