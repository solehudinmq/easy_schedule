require 'byebug'
require_relative "setup_db/pgsql"

class EasySchedule
  def self.connect_db(db_url)
    @connection = Pgsql.new(db_url)
  end

  def self.hi
    return "Hello World"
  end
end