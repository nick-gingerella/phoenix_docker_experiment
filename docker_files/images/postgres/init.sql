CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	age INTEGER
);

INSERT INTO students (name, age) VALUES
  ('nick', 25),
  ('bob', 30),
  ('hank', 40),
  ('meg', 19),
  ('peter', 27),
  ('tyler', 25);
