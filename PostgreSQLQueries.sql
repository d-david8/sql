-- Create a database called Twitter
CREATE DATABASE Twitter;

-- Create tables: users, addresses, messages
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) NOT NULL, 
	email VARCHAR (100) UNIQUE NOT NULL,
	password VARCHAR(100) NOT NULL
);
	
CREATE TABLE addresses(
	address_id SERIAL PRIMARY KEY, 
	user_id INT REFERENCES Users (user_id), 
	street_name VARCHAR (255) NOT NULL,
	city VARCHAR (50) NOT NULL, 
	zip_code VARCHAR (10)
);

CREATE TABLE messages(
	message_id SERIAL PRIMARY KEY, 
	user_id INT REFERENCES Users(user_id), 
	content TEXT,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a new user into the Users table.
INSERT INTO users(user_name, email,password)
VALUES ('d_david8','d_david8@yahoo.com','12hsja-912uhs8');

-- Retrieve all users from the Users table.
SELECT * FROM users

-- Change a user's email in the Users table.
UPDATE users SET email = 'dan.david8@icloud.com' where user_name = 'd_david8'
	
-- Delete a user from the Users table based on their username.
DELETE FROM users where user_name = 'd_david8';

-- Insert multiple records: Insert three more users into the Users table at once.
INSERT INTO users (user_name, email, password)
VALUES
    ('user4', 'user4@google.com', 'password4'),
    ('user5', 'user5@google.com', 'password5'),
    ('user6', 'user6@google.com', 'password6');
	
-- Specific select: Retrieve only the usernames and emails of all users from the Users table.
SELECT user_name, email FROM users;

-- Conditional select: Retrieve users from the Users table who have email addresses ending with "@example.com".
SELECT * FROM users where email like '%example.com';

-- Insert with reference: Insert an address for one of the users you added. 
-- Make sure to link it to the user using the user_id field in the Addresses table.
INSERT INTO addresses (user_id, street_name, city, zip_code)
VALUES ((SELECT user_id FROM users WHERE user_name = 'user1'), 'Street1', 'City1', '12345');

SELECT * FROM addresses;

-- Update with condition: Change all messages in the Messages table with the word "hello" 
-- in their content to "Hello World!".
INSERT INTO messages (user_id, content)
VALUES
    (2, 'Hello!'),
    (3, 'Hello!'),
    (2, 'What''s up?'),
    (3, 'Not much');
SELECT * FROM messages;

UPDATE messages SET content = 'Hello world!' WHERE content ILIKE 'hello_';

-- Delete with JOIN: Delete all addresses associated with users who have an email address ending 
-- with "@example.com". (This one introduces them to using JOIN with DELETE).
-- DELETE with JOIN not supported in PostgreSQL

DELETE FROM addresses as a
USING users as u
WHERE a.user_id = u.user_id and u.email like '%@example.com';

-- Aggregate function: Count the number of messages each user has sent and order the 
-- result by the number of messages in descending order.

SELECT u.user_id, u.user_name, COUNT(m.message_id) AS num_messages_sent
FROM users u
LEFT JOIN messages m ON u.user_id = m.user_id
GROUP BY u.user_id
ORDER BY num_messages_sent DESC;

-- Retrieve all messages along with the username of the person who sent them.
SELECT u.user_name, m.content
FROM users u
JOIN messages m ON u.user_id = m.user_id;

-- Find all messages sent in the last 7 days.

SELECT * FROM messages
WHERE timestamp > NOW() - INTERVAL '7 DAY';

-- Find all users whose usernames start with 'john'.
SELECT * FROM users
WHERE user_name like 'john%';

-- Find the total number of users from each city using the Addresses table.
SELECT city, COUNT(user_id) AS total_users
FROM Addresses
GROUP BY city;

-- Classify messages into 'Short' and 'Long' based on the length of their content 
-- (e.g., classify as 'Short' if the length is under 100 characters).
SELECT message_id, content,
    CASE
        WHEN LENGTH(content) < 10 THEN 'Short'
        ELSE 'Long'
    END AS message_length
FROM messages;

-- Retrieve the next 5 users starting from the third user in the Users table.
SELECT * FROM users OFFSET 3 LIMIT 5;

-- Retrieve all addresses sorted by city in ascending order and then by street_name in descending order.
SELECT * FROM addresses
ORDER BY city asc, street_name desc;

-- Find all unique cities from the Addresses table.
SELECT DISTINCT city
FROM addresses;

-- Find users whose usernames are 'john_doe', 'jane_doe', or 'sam_smith'.
SELECT * from users
WHERE user_name in('john_doe', 'jane_doe','sam_smith');

-- Find users who have not sent any messages.
SELECT u.*
FROM users u
LEFT JOIN messages m ON u.user_id = m.user_id
WHERE m.message_id IS NULL;

-- Retrieve all messages with both the username and the address (city) of the sender.
SELECT m.message_id, u.user_name, a.city, m.content
FROM messages m
INNER JOIN users AS u ON m.user_id = u.user_id
INNER JOIN addresses AS a ON u.user_id = a.user_id;

-- Find cities in the Addresses table that have more than 3 users.
SELECT city
FROM addresses
GROUP BY city
HAVING COUNT(user_id) > 3;

-- Calculate the average length of messages for each user, and display only those users who have 
-- an average message length greater than 50 characters.
SELECT u.user_id, u.user_name, AVG(LENGTH(m.content)) AS avg_message_length
FROM users u
INNER JOIN messages m ON u.user_id = m.user_id
GROUP BY u.user_id, u.user_name
HAVING AVG(LENGTH(m.content)) > 10;
