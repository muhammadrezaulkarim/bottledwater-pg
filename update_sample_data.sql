CREATE OR REPLACE FUNCTION update_sample_data(my_id INTEGER)
RETURNS BOOLEAN AS $passed$
DECLARE passed BOOLEAN;
DECLARE counter INTEGER;

BEGIN
   counter := 0;
  
   WHILE counter <= 50 LOOP
     update test set value='Modified hello world:' || counter where id=my_id;
	 counter := counter + 1 ; 
	 perform pg_sleep(0.5);
   END LOOP ; 
		
   passed := TRUE;
   RETURN passed;
   
END;
$passed$ LANGUAGE plpgsql;

START TRANSACTION;
select update_sample_data(5);
COMMIT;
