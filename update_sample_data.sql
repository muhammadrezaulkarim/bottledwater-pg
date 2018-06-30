CREATE OR REPLACE FUNCTION update_sample_data(my_id INTEGER)
RETURNS BOOLEAN AS $passed$
DECLARE passed BOOLEAN;
DECLARE counter INTEGER;

BEGIN
     counter := 0;
     
		 WHILE counter <= 20 LOOP
			 update test set value='Modified hello world:' || counter where id=my_id;
			 counter := counter + 1 ; 
		 END LOOP ; 
		
        
		passed := TRUE;
        
		RETURN passed;
END;
$passed$ LANGUAGE plpgsql;

COMMIT;
select update_sample_data(5);
