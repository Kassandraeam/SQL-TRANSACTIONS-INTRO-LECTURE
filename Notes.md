# Code I'm looking at #

router.post('/new', async (req, res) => {
  const name = req.body.name;
  const amount = req.body.amount;
  console.log(`Creating new account ${name} with initial balance of ${amount}`);

  const connection = await pool.connect();
  try {
    await connection.query('BEGIN;');
    const sqlAddAccount = `
    INSERT INTO "account" ("name")
    VALUES ($1)
    RETURNING "id";
    `;
    // Save query result to variable.
    const result = await connection.query(sqlAddAccount, [name]);
    const accountId = result.rows[0].id //the first row, and its id.
    
    const sqlInitialDeposit = 
    `
    INSERT INTO "register" ("acct_id", "amount")
    VALUES ($1, $2);
    ;`;
    await connection.query(sqlInitialDeposit, [accountId, amount]); //
    await connection.query('COMMIT;');
    res.sendStatus(200);
  } catch (error) {
    await connection.query('ROLLBACK');
    console.log('Error adding new account:', error)
    res.sendStatus(500);
  } finally {
    connection.release();
  }
})



# Things that were introduced: #
* Transactions: If 1 query fails, the rest fails as well. Helps prevent unwanted queries passing.
* async: Throw async after the route name and before the (req, res) to allow us to use try, catch, and finally. 
  ? What does async do ?
    √ Async makes sure that the thing we're working on always returns something. 
  ? Transactional queries are all or nothing. So it's async that makes that so ?

* await: Stops the operation until something is returned. Does not move forward until something is returned.
* Begin: Controls when we start our SQL query.
* Finally: Always runs after a successful try, and after catch.
* Commit: This is what indicates a success in the try block.
* Rollback: This is what indicates an error in the catch block.

? What is this saying ? 
  ? await connection.query('BEGIN');
  ? connection = await pool.connect();
  ? Therefore, await connection.query('BEGIN'); is equal to: 
  ? await await pool.connect().query('BEGIN'); ??? 
  ? Stop operations, stop operations, connect to pool, and send the query BEGIN?

* We can't just copy and paste this SQL query into our router:

    BEGIN;
    INSERT INTO "register" ("acct_id", "amount") VALUES (2, -500);
    INSERT INTO "register" ("acct_id", "amount") VALUES (1, 500);
    COMMIT;

Essentially how it's being broken down in our server request:
try { 
    BEGIN;
    INSERT INTO "register" ("acct_id", "amount") VALUES (2, -500);
    INSERT INTO "register" ("acct_id", "amount") VALUES (1, 500);
    COMMIT:
} 
catch {
    ROLLBACK;
}
finally {
    connection.release(); // ends the circuit.
}

! Biggest difference ?
* sqlAddAccount = Query Text we're using.
* [name] = Because this is a post, it's the information we're sending to POST to the DB.

pool.query(sqlAddAccount, [name]);
result = await connection.query(sqlAddAccount, [name]);
? The reason we're saving this as result is so that we save the information we got from our query is to drill into it, and then use THAT information in the next query ?

* connection.query(queryText, [information being sent]) is just our typical pool.query(queryText, [information being sent])
*/