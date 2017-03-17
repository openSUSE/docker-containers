# This is a rails runner that will print the status of Portus' database
# Possible outcomes:
#
#   * `DB_READY`: the database has been created and initialized
#   * `DB_EMPTY`: the database has been created but has not been initialized
#   * `DB_MISSING`: the database has not been created
#   * `DB_DOWN`: cannot connect to the database

def database_exists?
  ActiveRecord::Base.connection
  if ActiveRecord::Base.connection.table_exists? 'schema_migrations'
    puts "DB_READY"
  else
    puts "DB_EMPTY"
  end
rescue ActiveRecord::NoDatabaseError
  puts "DB_MISSING"
rescue Mysql2::Error
  puts "DB_DOWN"
end

database_exists?
