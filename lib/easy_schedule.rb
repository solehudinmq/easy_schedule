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
  def add_bulk_subject(bulk_data)
    @connection.add_bulk_subject(bulk_data)
  end
end