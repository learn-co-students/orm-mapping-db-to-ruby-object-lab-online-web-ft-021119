class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * From students
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * From students
      WHERE name = ?
      LIMIT 1
      SQL

      found_name = DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end
        found_name.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * From students
      WHERE grade = 9
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * From students
      WHERE grade < 12
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * From students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT ?
      SQL

      DB[:conn].execute(sql, x).map do |row|
        self.new_from_db(row)
      end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * From students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT 1
      SQL

      first_student = DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
      first_student.first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * From students
      WHERE grade = ?
      ORDER BY students.id
      SQL

      DB[:conn].execute(sql, x).map do |row|
        self.new_from_db(row)
      end
  end

end
