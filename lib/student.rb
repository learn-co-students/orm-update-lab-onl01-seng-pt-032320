require_relative "../config/environment.rb"
require "pry"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql_command = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql_command)
  end

  def self.drop_table
    sql_command = <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql_command)
  end

  def save
    if self.id
      self.update
    else
      sql_query = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql_query, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    id, name, grade = row
    student = self.new(name, grade, id)
    student
  end

  def self.find_by_name(name)
    sql_query = <<-SQL
      SELECT * FROM students WHERE name = ?;
      SQL
      row = DB[:conn].execute(sql_query, name)[0]
      new_from_db(row)
  end

  def update
    sql_command = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?;
      SQL
      DB[:conn].execute(sql_command, self.name, self.grade, self.id)
  end
end

#To clarify, I am not working on Tic Tac Toe, my account was paused because payment hasn't been received yet, even though it has been withdrawn from my bank account already.... So I am continuing while this stuff gets resolved by tomorrow