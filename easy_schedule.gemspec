Gem::Specification.new do |s|
  s.name  = "easy_schedule"
  s.version = "1.0"
  s.summary = "Easy and flexible scheduling"
  s.description = "Easy and flexible scheduling, with weekly and daily scheduling features"
  s.authors = ["Solehudin MQ"]
  s.email = "solehudinmq@gmail.com"
  s.files = ["lib/easy_schedule.rb", "lib/setup_db/pgsql.rb"]
  s.homepage  = "https://rubygems.org/gems/easy_schedule"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.5.0"
  s.add_runtime_dependency  "pg", "~> 1.0"
  s.add_development_dependency "rspec", "~> 1.0"
  s.add_development_dependency "byebug", "~> 1.0"
end