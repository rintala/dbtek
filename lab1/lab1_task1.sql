--LAB 1 - TASK 1



--UPG.1 - Who wrote ”The Shining”?
SELECT last_name, first_name 
	FROM authors 
		WHERE author_id = (SELECT author_id FROM books WHERE title='The Shining');


--UPG.2 - Which titles are written by Paulette Bourgeois?
 SELECT title 
 	FROM books 
 		WHERE author_id = (SELECT author_id 
 				FROM authors WHERE 
 					first_name='Paulette' AND last_name='Bourgeois');


--UPG.3 - Who bought books about “Horror”?
SELECT last_name, first_name 
	FROM customers 
		WHERE customer_id IN 
			(SELECT customer_id FROM shipments 
				WHERE isbn IN (SELECT isbn FROM editions 
						WHERE book_id IN (SELECT book_id FROM books 
								WHERE subject_id = (SELECT subject_id FROM subjects WHERE subject='Horror'))));


--UPG.4 - Which book has the largest stock?
SELECT title 
	FROM books 
		WHERE book_id = (SELECT book_id 
			FROM editions 
				WHERE editions.isbn = (SELECT isbn FROM stock WHERE stock=(SELECT MAX(stock) FROM stock)));


--UPG.5 - How much money has Booktown collected for the books about Science Fiction?
		--They collect the retail price of each book shiped.
		--Revenue per isbn (account for several shipments of same isbn)
		--Revenue summed per book_id
		--Revenue summed by subject_id
		--Revenue summed by subject
SELECT sum 
	FROM (SELECT subject_id, sum(sum)  			--per subject-id
		FROM (SELECT book_id, sum(revPerBook) 	--per book-id
			FROM editions 
				RIGHT JOIN (SELECT t1.isbn, count*retail_price as revPerBook 
					FROM (SELECT isbn, count(*) FROM shipments GROUP BY isbn) AS t1 
						LEFT JOIN (SELECT isbn, retail_price FROM stock) AS t2 
							ON t1.isbn = t2.isbn) AS revPerBook 
				ON revPerBook.isbn = editions.isbn 
		GROUP BY book_id) AS sumSubject 
						LEFT JOIN books ON books.book_id=sumSubject.book_id 
	GROUP BY subject_id) AS subSum 
						LEFT JOIN subjects ON subjects.subject_id = subSum.subject_id WHERE subject='Science Fiction';


--UPG.6 - Which books have been sold to only two people?
		--Note that some people buy more than one copy and some books appear as several editions.
			-- Info fran editions - ga pa book_id (unik for varje bok)
		-- Select relevant book_id.s med count GROUP BY book_id
		-- Select title fran dessa book_id:s
		-- GROUP BY book_id => for att summera antal customers per book

SELECT title FROM books 
	WHERE book_id IN (SELECT book_id 
		FROM (SELECT editions.book_id, COUNT(customer_id) as count 
			FROM shipments 
				LEFT JOIN editions ON editions.isbn = shipments.isbn GROUP BY editions.book_id) AS bookCount 
					WHERE count=2);


--UPG.7 - Which publisher has sold the most to Booktown?
		--Note that all shipped books were sold at ‘cost’ to as well as all the books in the stock.
		--Tabell over alla shipments och dess inkopskostnad
		--Tabell over alla shippade ISBN och dess summerade inkopskostnad
		--UNION av 1 & 2, med ISBN och dess aggregerad inköpskostnader
		--RIGHT JOIN (NO NULL PRICES) GROUP BY ISBN OCH SUMMERA COST
		--GROUP BY PUBLISHER_ID (from Editions) OCH SUMMER COST
		--FIND PUBLISHER_ID OF MAX COST
		--INNER JOIN TO GET PUBLISHER NAME W. MAX COST = result

SELECT name, sum FROM publishers 
	INNER JOIN (SELECT * 
		FROM (SELECT publisher_id, sum(totCostPublisher.totCost) 
			FROM (SELECT * 
				FROM(SELECT isbn, sum(totCost) AS totCost 
					FROM(SELECT * 
						FROM(SELECT shipments.isbn, SUM(stock.cost) as totCost 
							FROM shipments RIGHT JOIN stock ON stock.isbn = shipments.isbn 
								GROUP BY shipment_id) AS costShipments 
									UNION SELECT isbn, cost*stock AS totCost FROM stock) AS totCostTable GROUP BY isbn) AS totCostTable 
										LEFT JOIN editions ON editions.isbn = totCostTable.isbn) as totCostPublisher 
											GROUP BY publisher_id) AS maxTable 
												ORDER BY sum DESC LIMIT 1) AS mTable ON mTable.publisher_id = publishers.publisher_id;


--UPG.8 - How much money has Booktown earned (so far)? 
		-- Explain to the teacher how you reason about the incomes and costs of Booktown 
		-- We reason that we only look at the actual books sold, i.e. the rel. shipments
			-- thus we wont include the amt. payed for inventory or stock which have yet not been sold
			-- i.e. the diff = retail_price - cost
SELECT SUM(diff) 
	FROM (SELECT isbn, (retail_price-cost) AS diff 
		FROM shipments NATURAL JOIN stock) AS diffISBN;


--UPG.9 - Which customers have bought books about at least three different subjects?
		--GETTING book_ids for all customer_ids who have been shipped to:
		--Customer_id & subject_id:
		--Customer_id & counted distinct subject_id:s:
		--Customer_ids with >=3 different subject_id:s:
		--Finding Customer last_name & first_name - RESULT

SELECT last_name, first_name FROM customers 
	INNER JOIN (SELECT * 
		FROM (SELECT customer_id, COUNT(DISTINCT subject_id) AS countSubjects 
			FROM (SELECT customer_id, subject_id FROM books 
				INNER JOIN (
					SELECT customer_id, book_id FROM editions 
						INNER JOIN shipments ON shipments.isbn = editions.isbn) AS cbID ON cbID.book_id = books.book_id) as countPerCustomer 
					GROUP BY customer_id) as tt 
							WHERE countsubjects >=3) AS selCustomer ON selCustomer.customer_id = customers.customer_id;

--UPG.10 - Which subjects have not sold any books?
SELECT subject 
	FROM subjects 
		WHERE subject_id NOT IN (SELECT DISTINCT subject_id 
			FROM books 
				LEFT JOIN editions ON editions.book_id = books.book_id);



