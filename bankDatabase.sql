-- 1. Insert into account
INSERT INTO "account" ("name")
VALUES
('KAS MONEY')
SELECT * FROM "account";


INSERT INTO "register" ("acct_id", "amount") VALUES (1, 1000);
SELECT * FROM "register";

INSERT INTO "account" ("name") VALUES ('Eric''s Vacation Fund') 
RETURNING "id"

INSERT INTO "register" ("acct_id", "amount") VALUES (2, 2000);

-- Take 500 outta Eric's account, insert another row into the register with a negative ammount
INSERT INTO "register" ("acct_id", "amount") VALUES (2, -500);

INSERT INTO "register" ("acct_id", "amount") VALUES (2, -500);
INSERT INTO "register" ("acct_id", "ammount" VALUES (1, 500);

BEGIN;
INSERT INTO "register" ("acct_id", "amount") VALUES (2, -500);
INSERT INTO "register" ("acct_id", "amount") VALUES (1, 500);
COMMIT;

-- We want to see the sum of Each person's account.
SELECT "account"."name", SUM("register"."amount")
FROM "account"
JOIN "register" ON "account".id = "register".id
GROUP BY "account".name;