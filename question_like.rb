require_relative 'questions_db'

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
end