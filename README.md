# Account Movements CSV

## Proposition

This project exposes a command line interface to process CSV files of account transactions.

## How to use

The main script is exposed through the `docker-compose` interface.  

To run it:
`docker-compose run app <accounts-csv-path> <transactions-csv-path>`  

There is some sample data inside the root `data` folder, that folder is already declared as the container volume, so any file inside it would be visible to the container.  

Running the example:  
`docker-compose run app /data/sample_accounts.csv /data/sample_transactions.csv`  

## Input format

The CSV files must have `,` separators and no quote chars.

### Accounts

For the accounts CSV, the first column is the `account_id` and the second column is the `initial balance` of the account, expressed as cents. Both values should be Integers. `account_id` should be positive.

Example:  
1,100  
2,334  

### Transactions

For the transactions CSV, the first column is the `account_id` and the second column is the `transaction value`, expressed as cents. For positive values of transactions, it will be a deposit into the account, negative values will represent an withdraw. Both values should be Integers. `account_id` should be positive.

Example:  
1,-100  
2,4000  

## Output format

The script will output the accounts balance after the transactions are processed into the STDOUT.
One account per line, with the balance values expressed as cents.

Example:  
1,30000  
2,-5300

## Business Rules

Each transaction that would change the account into a negative balance is charged with a aditional fee of R$3,00.

## Processing accounts

The accounts are processed in order as they appear in the CSV file, if there are duplicated values, the last value in the file would be considered.

For example:  
2,200  
2,-300  

The initial balance of the account 2 would be -R$3,00.

## Processing Transactions

The transactions are processed in the order as they appear in the CSV file, if there is an account_id that does not have an initial balance, that account is processed as a zero balance account.

For example  
1,200  
2,300  

accounts:  
1,290

The final balance would be  
1,490  
2,300

## Running the test suite
To run the application test suite run:  
`docker-compose run --entrypoint rspec app`

## Design considerations
To keep things simple, all the data manipulation is kept in memory.
Some know drawbacks of this approach is that we will not be able to maintain state between files processed, it will not be possible to process some file from line 50 onwards, for instance.
At the moment, the aplication validates the CSV file as it is reading it, it should be able to show what line of the file has a problem, so we could fix it and try again.

We had utilized `CSV.foreach` method to make it possible to read large CSV files, as it reads the file from the disk, line by line, and does not load the file entirely on the memory.

To improve the solution, we could use some database to maintain state between file processing. The behavior of existing accounts should be refined further, "are they overridden or not?"

## Dependencies  
The only dependency of the project is the `rspec` gem, it is a standard library for testing and provides a nice behavior driven approach on wrinting the tests.
