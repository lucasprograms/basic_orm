require 'active_support/inflector'
require_relative './questions_db'

class ModelBase
  def self.table
    self.to_s.tableize
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = ?
    SQL

    data.nil? ? nil : self.new(data.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    data.nil? ? nil : data.map { |datum| self.new(datum) }
  end

  def self.first
    self.find_by_id(1)
  end

  # def save
  #   @id ? self.update : self.create
  # end

  # def create
  #   print 'create'
  # end

  # def update
  #   instance_variables = self.instance_variables[1..-1].join(', ') + ', @id'
  #   QuestionsDatabase.instance.execute(<<-SQL, "#{instance_variables}")
  #     UPDATE
  #       users
  #     SET
  #       fname = ?, lname = ?
  #     WHERE
  #       id = ?      
  #   SQL
  # end

  # #{instance_variables[1..-1].map { |el| el.to_s[1..-1] }.join(' = ?, ')} = ?
end