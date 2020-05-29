require 'sqlite3'
require_relative '../lib/student'
require 'byebug'

DB = {:conn => SQLite3::Database.new("db/students.db")}