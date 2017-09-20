## --- LAB 2 ---

Using Booktown DB - implemented on local server
  - initialized by running provided file create.sql
  
## - TASK 1: Basic Application Program
  - interface.py
  - Using code skeleton - completing two unfinished methods for DB interaction:
        - insert
        - remove
        
## - TASK 2: Simple Application Program
  - customerInterface.py
  - Using code skeleton
      - Get input of customer_id and name from user
      - Check it against the customer table
      - Then print a listing of (shipment_id, ship_date, isbn, title)
      - Prevent crashing when incorrect input & prevent SQL injection attacks

## - TASK 3: Not as Simple Application Program
  - shipmentInterface.py
  - Using code skeleton - providing interface for employees to enter shipments
      - Finish the makeShipments function
      - Same type of SQL preventions as in TASK 2
      - Handle transactions - with defined rollbacks and commits
      - Should ask for the shipment info
      - Then test if there is a book to ship
      - If so, insert the shipment and decrement the DB
