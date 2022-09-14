CREATE TABLE account (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL
);

CREATE TABLE register (
	id SERIAL PRIMARY KEY,
  acct_id INTEGER REFERENCES account ON DELETE CASCADE NOT NULL,	amount MONEY NOT NULL
);

-- Lecture --

CREATE TABLE account (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL
);

CREATE TABLE register (
	id SERIAL PRIMARY KEY,
  acct_id INTEGER REFERENCES account ON DELETE CASCADE NOT NULL,
  amount MONEY NOT NULL
);

-- 1. Insert into account
INSERT INTO "account" ("name")
VALUES
('KAS MONEY')
SELECT * FROM "account";


INSERT INTO "register" ("acct_id", "amount")
VALUES 
(1, 1000);