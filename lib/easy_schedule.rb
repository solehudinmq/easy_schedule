require 'byebug'
require_relative "db/pgsql"

class EasySchedule
  # connect to postgresql database and create type and table
  # 1. db_url (required) = 'db_url' is a URL to be able to connect to a pgsql database
  #    example = 'postgresql://username:password@x.x.x.x:5432/database_name?sslmode=require'
  def initialize(db_url)
    @connection = Pgsql.new(db_url)
  end

  # if the config data does not exist, please run this method to create the config data.
  # 1. subject_name (required) : 'subject' is the name of the schedule, for example the subject is 'Doctor' then it will be considered as the 'Doctor's schedule'
  #    example = 'Doctor'
  # 2. limit_schedule (optional) : 'limit_schedule' is the maximum limit that each schedule can add a subject
  #    example = '20' (default '10' if not filled in)
  # 3. timezone (optional) : 'timezone' set for the time on the schedule
  #    example = 'America/New_York' (default 'Asia/Jakarta' if not filled in)
  def config_seed(subject_name, limit_schedule='10', timezone='Asia/Jakarta')
    @connection.config_seed(subject_name, limit_schedule, timezone)
  end

  # insert bulk data into table subjects 
  # 1. bulk_data (required) : bulk subject data to be inserted into the database
  #    example : [{ name: 'Tono', phone_number: '+62xxxxxxxxxxxx', gender: 'MALE' }, { name: 'Indah', phone_number: '+62xxxxxxxxxxxx', gender: 'FEMALE' }]
  def insert_bulk_data_subject(bulk_data)
    @connection.insert_bulk_data_subject(bulk_data)
  end

  # insert bulk data into table schedules 
  # 1. bulk_data (required) : bulk schedule data to be inserted into the database
  #    example : [{ day: 'MONDAY', start_schedule: '10 AM', end_schedule: '11 AM' }, { day: 'MONDAY', start_schedule: '2 PM', end_schedule: '4 PM' }]
  #    description : 
  #     - day = day is the name of the day
  #       example = 'SUNDAY' / 'MONDAY' / 'TUESDAY' / 'WEDNESDAY' / 'THURSDAY' / 'FRIDAY' / 'SATURDAY'
  #     - start_schedule = start_schedule is the schedule start time
  #       example = '1 AM' / '2 AM' / '3 AM' / '4 AM' / '5 AM' / '6 AM' / '7 AM' / '8 AM' / '9 AM' / '10 AM' / '11 AM' / '12 AM' / '1 PM' / '2 PM' / '3 PM' / '4 PM' / '5 PM' / '6 PM' / '7 PM' / '8 PM' / '9 PM' / '10 PM' / '11 PM' / '12 PM'
  #     - end_schedule = end_schedule is the schedule end time
  #       example = '1 AM' / '2 AM' / '3 AM' / '4 AM' / '5 AM' / '6 AM' / '7 AM' / '8 AM' / '9 AM' / '10 AM' / '11 AM' / '12 AM' / '1 PM' / '2 PM' / '3 PM' / '4 PM' / '5 PM' / '6 PM' / '7 PM' / '8 PM' / '9 PM' / '10 PM' / '11 PM' / '12 PM'
  def insert_bulk_data_schedule(bulk_data)
    @connection.insert_bulk_data_schedule(bulk_data)
  end
end