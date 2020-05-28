require_relative "../config/environment.rb"

# Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INT PRIMARY KEY, 
        name TEXT, 
        grade INT
      )
      SQL
      DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
      DB[:conn].execute(sql)
  end

  def save
    if self.id
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else 
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end

  def self.create(name, grade)
    self.new(name, grade).save
  end 

  def self.new_from_db(row)
    student = self.new(row[1],row[2])
    student.save
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name).first
    Student.new(result)
  end


end
