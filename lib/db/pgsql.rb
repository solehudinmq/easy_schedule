require 'pg'

class Pgsql
  # setup connection db
  def initialize(db_url)
    begin
      @connection = PG::Connection.new( db_url )

      db_setup
    rescue PG::Error => err
      @connection.reset

      raise "Pgsql database error connection : #{err.message}"
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
      PRIMARY KEY (id),
      constraint unique_phone_number unique (phone_number)
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

  # input data into table configs
  def config_seed(subject_name, limit_schedule, timezone)
    insert_data('configs', "(key, value, value_as)", "('subject_name', '#{subject_name}', 'STRING'), ('limit_schedule', '#{limit_schedule}', 'INTEGER'), ('timezone', '#{timezone}', 'STRING')")
  end

  # insert bulk data into table subjects
  def add_bulk_subject(bulk_data)
    raise 'Bulk data must be an array' unless bulk_data.is_a?(Array)
    raise 'Bulk data should not be blank' if bulk_data.length < 1

    insert_datas = ""
    last_data = bulk_data.length - 1
    bulk_data.each_with_index do |data, idx|
      temp_data = "('#{data[:name]}', '#{data[:phone_number]}', '#{data[:gender]}')"

      if idx < last_data
        temp_data += ', '
      end

      insert_datas += temp_data
    end

    insert_data('subjects', "(name, phone_number, gender)", "#{insert_datas}")
  end

  private
  # setup data type
    def type_setup(name, values)
      pgsql_exec("DO $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = '#{name}') THEN
                create type #{name} AS ENUM #{values};
            END IF;
        END
      $$;")
    end

    # setup data table
    def table_setup(name, values)
      pgsql_exec("CREATE TABLE IF NOT EXISTS #{name} #{values}")
    end

    # insert data to table
    def insert_data(selection_table, keys, values)
      pgsql_exec("INSERT INTO #{selection_table}#{keys} VALUES #{values};")
    end

    # pgsql response
    def pgsql_exec(query)
      @connection.exec(query) do |result|
        puts "STATUS : #{result.res_status}"
        puts "SUCCESS MESSAGE : #{result.result_status}"
        puts "ERROR MESSAGE : #{result.result_error_message}"
      end
    end
end