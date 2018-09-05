require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

class Reply
  attr_accessor :body, :question_id, :parent_reply_id, :author_id

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
  end

  def Reply.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    Reply.new(data.first)
  end

  def Reply.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def Reply.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(data.first)
  end

  def question
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(data.first)
  end

  def parent_reply
    data = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    data.empty? ? nil : Reply.new(data.first)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL

    Reply.new(data.first)
  end
end