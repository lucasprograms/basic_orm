require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

class QuestionFollow
  attr_accessor :question_id, :follower_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end

  def QuestionFollow.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    QuestionFollow.new(data.first)
  end

  def QuestionFollow.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.follower_id
      WHERE
        question_id = ?
    SQL
    
    data.map { |datum| User.new(datum) }
  end

  def QuestionFollow.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.body, questions.title, questions.author_id
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.follower_id
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        question_follows.follower_id = ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def QuestionFollow.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.body, questions.title, questions.author_id
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.follower_id) DESC
      LIMIT
        ?
    SQL

    data.map { |datum| Question.new(datum) }
  end
end