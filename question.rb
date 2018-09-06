require_relative 'questions_db'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'model_base'

class Question < ModelBase
  attr_accessor :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
        UPDATE
          questions
        SET
          title = ?, body = ?, author_id = ?
        WHERE
          id = ?      
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
        INSERT INTO
          questions (title, body, author_id)
        VALUES
          (?, ?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  def Question.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL

    Question.new(data.first)
  end

  def Question.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
      SQL

    Question.new(data.first)
  end

  def Question.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def Question.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(data.first)
  end

  def replies
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
