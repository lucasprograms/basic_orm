require_relative 'questions_db'
require_relative 'user'

class QuestionLike
  attr_accessor :question_id, :liker_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @liker_id = options['liker_id']
  end

  def QuestionLike.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
      SQL

    QuestionLike.new(data.first)
  end

  def QuestionLike.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON question_likes.liker_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    data.map { |datum| User.new(datum) } 
  end

  def QuestionLike.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.liker_id) AS Likes
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    data.first['Likes']
  end

  def QuestionLike.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      JOIN
        users ON users.id = question_likes.liker_id
      WHERE
        question_likes.liker_id = ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def QuestionLike.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.question_id) DESC
      LIMIT
        ?
    SQL

    data.map { |datum| Question.new(datum) }
  end
end