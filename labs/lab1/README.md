## --- LAB 1 ---

Using Booktown DB - run SQL queries to answer given problems, alter DB, set triggers

## TASK 1: SQL
- Queries in file: lab1_task1.sql
- Formulating SQL queries that correspond to a number of questions (1-10)

## TASK 2: View, insert, delete, update, constraint
- Tests in file: lab1_task2.sql
- Creating own copy of DB, using the given create.sql

## TASK 3: Triggers
- Trigger function and tests of trigger in file: lab1_task3.sql
- Continue working from own private copy of Booktown
- Writing and setting a trigger (in plpgsql)
    - Functioning so that whenever a new shipment is recorded => the stock is automatically decreased accordingly
    - If no stock is available, prompt error message 'No stock to ship'
