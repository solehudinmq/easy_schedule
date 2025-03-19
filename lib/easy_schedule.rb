require 'byebug'
require_relative "db/pgsql"

class EasySchedule
  # connect to postgresql database and create type and table (required)
  def initialize(db_url)
    @connection = Pgsql.new(db_url)
  end

  # if the config data does not exist, please run this method to create the config data. (optional)
  def config_seed(subject_name, limit_schedule=10, timezone='Asia/Jakarta')
    @connection.config_seed(subject_name, limit_schedule, timezone)
  end

  def self.hi
    return "Hello World"
  end
end