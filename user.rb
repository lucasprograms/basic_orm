require_relative 'questions_db'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User
  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def User.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL

    User.new(data.first)
  end

  def User.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
      SQL

    User.new(data.first)
  end

  def authored_questions
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
      SQL

    data.map { |datum| Question.new(datum) }
  end

  def authored_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end
end