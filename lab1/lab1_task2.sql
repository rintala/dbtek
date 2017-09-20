--LAB 1 - TASK 2

--UPG.1 - Create a view that contains isbn and title of all the books in the database. Then
		--query it to list all the titles and isbns. Then delete (drop) the new view. Why
		--might this view be nice to have?

	--CREATE:
	CREATE VIEW viewisbntitle AS SELECT isbn, title 
		FROM editions 
			LEFT JOIN books ON books.book_id = editions.book_id;

	--QUERY TO SHOW THE VIEW:
	SELECT * FROM viewisbntitle;

	--DELETE:
	DROP VIEW viewisbntitle;


	--COMMENTS:
		--Creating a temporary SQL view & naming it
		--Being able to access this spec. data whenever needed - much more convenient and 
		--providing nice overview when working with many relations


--UPG.2 - Try to insert into editions a new tuple ('5555', 12345, 1, 59, '2012-12-02').
		--Explain what happened.
	INSERT INTO editions(isbn, book_id, edition, publisher_id, publication_date)
		VALUES ('5555', 12345, 1, 59, '2012-12-02');

	-- ERROR:  insert or update on table "editions" violates foreign key constraint "editions_book_id_fkey"
	-- DETAIL:  Key (book_id)=(12345) is not present in table "books".

	--COMMENTS:
		-- seems the foreign_key constraint from editions is violated, since 12345 is not present in table books
		-- i.e. a book_id must exist in books, before an editions of this book can be inserted w. book_id
		-- From create.sql:
			--"book_id" integer references books(book_id)


--UPG.3 - Try to insert into editions a new tuple only setting its isbn='5555'. 
		--Explain what happened.
	INSERT INTO editions(isbn) VALUES('5555');
	-- ERROR:  new row for relation "editions" violates check constraint "integrity"
	-- DETAIL:  Failing row contains (5555, null, null, null, null).

	--COMMENTS:
		-- Seems the 'integrity' constraint in editions is violated, which states the fields cannot be NULL
		-- From create.sql: 
			--CONSTRAINT "integrity" CHECK (((book_id NOTNULL) AND (edition NOTNULL)))


--UPG.4 - Try to first insert a book with (book_id, title) of (12345, 'How I Insert') 
		--then One into editions as in 2. 
		--Show that this worked by making an appropriate query of the database. 
		--Why do we not need an author or subject?
				-- Iom. att vi anger book_id (primary_key och inte interferear med nagra constraints)

	INSERT INTO books(book_id, title) 
		VALUES (12345,'How I Insert');

	--Prompt: INSERT 0 1

	INSERT INTO editions(isbn, book_id, edition, publisher_id, publication_date)
		VALUES ('5555', 12345, 1, 59, '2012-12-02');
	--Prompt: INSERT 0 1

	-- Query to check/verify input:
	SELECT book_id, title FROM books WHERE book_id=12345;


--UPG.5 - Update the new book by setting the subject to ‘Mystery’.
	UPDATE books SET subject_id = (SELECT subject_id 
		FROM subjects WHERE subject='Mystery') 
			WHERE book_id=12345;
	--Prompt: UPDATE 1


--UPG.6 - Try to delete the new tuple from books. Explain what happens.
	DELETE FROM books WHERE book_id=12345;
	
	--ERROR:  update or delete on table "books" violates foreign key constraint "editions_book_id_fkey" on table "editions"
	--DETAIL:  Key (book_id)=(12345) is still referenced from table "editions".

	--COMMENTS:
		-- The foreign key constraint in editions is now violated, since book_id=12345 now exists in both
		-- editions and books <=> related through key book_id - must specify how to handle key in editions when deleting
		-- book_id from books

--UPG.7 - Delete both new tuples from step 4 and query the database to confirm.
	DELETE FROM editions WHERE book_id=12345;
	--Prompt: DELETE 1

	DELETE FROM books WHERE book_id=12345;
	--Prompt: DELETE 1

	--COMMENTS:
		-- Have to do it in the right order - not violate constraint

	--QUERY TO CONFIRM:
	SELECT * FROM books;

-- UPG.8 - Now insert a book with (book_id, title, subject_id ) of (12345, 'How I Insert', 3443).
	--Explain what happened
	INSERT INTO books(book_id,title,subject_id) VALUES(12345,'How I Insert',3443);
	
	--ERROR:  insert or update on table "books" violates foreign key constraint "books_subject_id_fkey"
	--DETAIL:  Key (subject_id)=(3443) is not present in table "subjects".

	--COMMENTS:
		-- since subject_id is not an existing key in subjects, we have to add it there first
		-- cannot add it in that order

-- UPG.9 -  Create a constraint, called ‘hasSubject’ that forces the subject_id to not be NULL
		-- and to match one in the subjects table. (HINT you might want to look at chap.
		-- 6.1.6 on testing NULL). Show that you can still insert an book with no author_id
		-- but not without a subject_id. Now remove the new constraint and any added books.

		--ALTER TABLE [Table] ADD CONSTRAINT [Constraint] DEFAULT 0 FOR [Column];
		--ALTER TABLE [Table] ALTER COLUMN [Column] INTEGER NOT NULL;

		ALTER TABLE books ALTER COLUMN subject_id SET NOT NULL;
		--Prompt: ALTER TABLE

		INSERT INTO books(book_id,title,subject_id) VALUES(13,'test',3);
		--Prompt: INSERT 0 1

		INSERT INTO books VALUES(123,'t',1212);
		--ERROR:  null value in column "subject_id" violates not-null constraint
		--DETAIL:  Failing row contains (123, t, 1212, null).

		DELETE FROM books WHERE book_id=13;

		ALTER TABLE books ALTER COLUMN subject_id DROP NOT NULL;
		--Prompt: ALTER TABLE

		--COMMENTS:
			--Dropping the constraint we put on subject_id column in books











