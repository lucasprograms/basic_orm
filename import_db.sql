PRAGMA foreign_keys = ON;

-- CREATE TABLE plays (
--   id INTEGER PRIMARY KEY,
--   title TEXT NOT NULL,
--   year INTEGER NOT NULL,
--   playwright_id INTEGER NOT NULL,

--   FOREIGN KEY (playwright_id) REFERENCES playwrights(id)
-- );

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Lucas', 'McCain'),
  ('Edmund', 'Wright'),
  ('Simon', 'Thompson'),
  ('Eduardo', 'Chavez');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('CATS', 'CATS CATS CATS', 1),
  ('DOGGOS', 'DOGGOS DOGGOS DOGGOS', 2),
  ('RATS', 'RATS RATS RATS', 1),
  ('PANTS', 'PANTS PANTS PANTS', 4);

INSERT INTO
  question_follows (question_id, follower_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 1),
  (4, 4),
  (3, 3),
  (1, 2),
  (3, 2);

INSERT INTO
  replies (body, question_id, parent_reply_id, author_id)
VALUES
  ('I like cats', 1, NULL, 2),
  ('I also like cats', 1, 1, 1),
  ('I hate my life', 4, NULL, 4);

INSERT INTO
  question_likes (question_id, liker_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (2, 3),
  (2, 2);


