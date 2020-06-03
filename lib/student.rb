require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
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
      #self.update
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
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql_query = <<-SQL
      SELECT * FROM students WHERE name = ?;
      SQL
      row = DB[:conn].execute(sql_query, name)
      new_from_db(row)
  end

  #def update
end