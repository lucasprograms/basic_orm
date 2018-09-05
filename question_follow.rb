require_relative 'questions_db'
require_relative 'user'

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
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.follower_id
      WHERE
        question_id = ?
    SQL
    
    data.map { |datum| User.new(datum) }
  end
end