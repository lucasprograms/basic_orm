require_relative 'questions_db'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'model_base'

class User < ModelBase
  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
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

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, @id, @id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / (SELECT COUNT(questions.id) FROM questions WHERE questions.author_id = ?) AS average_karma
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      WHERE
        questions.author_id = ?
    SQL

    data.first['average_karma']
  end
end