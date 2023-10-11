-- CREATE TABLE students(
-- 	student_id SERIAL PRIMARY KEY,
-- 	first_name VARCHAR(50),
-- 	last_name VARCHAR(50),
-- 	date_of_birth DATE,
-- 	email VARCHAR(50) UNIQUE,
-- 	phone VARCHAR(30)
-- );

-- CREATE TABLE courses(
-- 	course_id SERIAL PRIMARY KEY,
-- 	course_name VARCHAR(100),
-- 	course_description TEXT,
-- 	start_date DATE,
-- 	end_date DATE,
-- 	credits INT
-- );

-- INSERT INTO students(first_name, last_name, date_of_birth, email, phone)
-- VALUES('John','Doe','2001-07-03','joe@gmail.com','0740123456');

-- CREATE TABLE enrollments(
-- 	enromlment_id SERIAL PRIMARY KEY,
-- 	student_id INT REFERENCES students(student_id),
-- 	course_id INT REFERENCES courses(course_id),
-- 	enrollment_date DATE
-- );

-- INSERT INTO courses(course_name, course_description, start_date, end_date, credits)
-- VALUES ('Math','Math concepts','2023-9-10','2024-6-25',2);

-- INSERT INTO enrollments(student_id, course_id, enrollment_date)
-- VALUES (1,1,'2023-12-12')

-- Display all courses a student named "John Doe" is enrolled in.
-- SELECT c.course_name
-- FROM courses c
-- JOIN enrollments e ON c.course_id = e.course_id
-- JOIN students s ON s.student_id = e.student_id
-- WHERE s.first_name ='John' AND last_name = 'Doe'


-- SELECT * FROM courses;
-- SELECT * FROM enrollments;
-- SELECT COUNT(*) FROM students;

-- CREATE INDEX  idx_email ON students(email);
-- CREATE INDEX  idx_date_of_birth ON students(date_of_birth);

-- EXPLAIN ANALYZE SELECT * from students where email = 'john@gmail.com'; --0.1 ms after index 0.04
-- EXPLAIN ANALYZE SELECT * from students where date_of_birth BETWEEN '1900-2-2' AND '2002-2-2'; --30 ms  after index 15 ms

-- DO $$ 
-- DECLARE
--     i integer := 0;
-- BEGIN
--     FOR i IN 1..10000 LOOP
--         INSERT INTO students(first_name, last_name, email, date_of_birth)
--         VALUES (
--             chr(trunc(65 + random()*25)::int) || chr(trunc(65 + random()*25)::int),  -- Random 2 letter first name
--             chr(trunc(65 + random()*25)::int) || chr(trunc(65 + random()*25)::int),  -- Random 2 letter last name
--             md5(random()::text),  -- Random email (not perfect, but serves for dummy data)
--             CURRENT_DATE - (random() * 365 * 30)::int  -- Random DOB within the last 30 years
--         );
--     END LOOP;
-- END $$;