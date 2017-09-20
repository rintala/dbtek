--LAB 1 - TASK 3

-- Write a trigger that functions so that, whenever a new shipment
-- is recorded the stock is automatically decreased to reflect shipment
	-- if current stock=0 => prevent insertion
		-- raise 'EXCEPTION' with error-message 'There is no stock to ship'

--TRIGGER FUNCTION
CREATE FUNCTION decstock() RETURNS trigger AS $pname$
	BEGIN
		--CONDITION
		IF ((SELECT stock FROM stock WHERE stock.isbn = NEW.isbn) = 0) 
			--ACTION 1
			THEN RAISE EXCEPTION 'There is no stock to ship';
			
		ELSE
			--ACTION 2
        	UPDATE stock AS stk SET (stock) = (stock - 1) 
        		WHERE stk.isbn = NEW.isbn;
		END IF;

		RETURN NEW;
	END;
$pname$ LANGUAGE plpgsql;	--Can use virtually every language - ex. C/Java - if specified

CREATE TRIGGER stockTrigger
	--EVENT
		--BEFORE indicates we are using the DB-state before the trig. event
	BEFORE INSERT ON shipments
	FOR EACH ROW
		EXECUTE PROCEDURE decstock();
	--OBS. No need of REFERENCING statement since we use keyword NEW


--DEMONSTRATION OF TRIGGER
SELECT * FROM stock;

INSERT INTO shipments
	VALUES(2000, 860, '0394900014', '2012-12-07');
	--Should prompt Error message - no stock to ship

INSERT INTO shipments
	VALUES(2001, 860, '044100590X', '2012-12-07');
	--Prompt: INSERT 0 1

SELECT * FROM shipments 
	WHERE shipment_id > 1999;

SELECT * FROM stock;

DELETE FROM shipments 
	WHERE shipment_id > 1999;

UPDATE stock SET stock = 89 
	WHERE isbn = '044100590X';

DROP FUNCTION decstock() CASCADE;
--Removes trigger and function from the DB


