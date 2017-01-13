/*trigger for flagging flushing status
A80974 and D80974 are delta tables for sewer gravity main flushing report table
A71030 is delta table for ssGravityMain feature class
A81268 and D81268 are delta tables for sewer manhole flushing report table
A71017 is delta table for sManhole feature class
*/
CREATE OR REPLACE TRIGGER RPUD.flushingGM_status 
 BEFORE INSERT ON RPUD.A438207
 FOR EACH ROW
 -- DECLARE 
 -- 	sde_sid number;
 BEGIN
 	-- SELECT MAX(SDE_STATE_ID) INTO sde_sid FROM RPUD.A71030;
	UPDATE RPUD.A438224
	SET RPUD.A438224.ISFLUSHED = 1
	WHERE RPUD.A438224.FACILITYID = :new.FACILITYID;
 END;
 /

CREATE OR REPLACE TRIGGER RPUD.flushingMH_status 
 BEFORE INSERT ON RPUD.A438206
 FOR EACH ROW
 -- DECLARE 
 -- 	sde_sid number;
 BEGIN
 	-- SELECT MAX(SDE_STATE_ID) INTO sde_sid FROM RPUD.A71017;
	UPDATE RPUD.A438220
	SET RPUD.A438220.ISFLUSHED = 1
	WHERE RPUD.A438220.FACILITYID = :new.FACILITYID;
 END;
 /

---- Not an ideal practice, deletion will fail if data have been compressed
-- CREATE OR REPLACE TRIGGER RPUD.resetflushingGM_status
--  BEFORE INSERT ON RPUD.D80974
--  FOR EACH ROW
--  DECLARE
--  	pragma autonomous_transaction; --for solving reconcile issue
-- 	total_ANum number;
-- 	total_DNum number;
-- 	fac_id string(20);
-- 	 BEGIN
-- 		SELECT FACILITYID INTO fac_id FROM RPUD.A80974 WHERE OBJECTID = :NEW.SDE_DELETES_ROW_ID AND ROWNUM=1;
-- 		IF fac_id IS NULL THEN
-- 			SELECT COUNT(*) INTO total FROM RPUD.SEWERMAINFLUSHING WHERE 
-- 		SELECT COUNT(*) INTO total_ANum FROM RPUD.A80974 WHERE FACILITYID = fac_id;
-- 		SELECT COUNT(*) INTO total_DNum FROM RPUD.D80974 WHERE SDE_DELETES_ROW_ID IN (SELECT DISTINCT OBJECTID FROM RPUD.A80974 WHERE FACILITYID = fac_id);
-- 		IF total_ANum = total_DNum + 1 THEN
-- 		 	UPDATE RPUD.A71030
-- 		 	SET RPUD.A71030.ISFLUSHED = 0
-- 		 	WHERE RPUD.A71030.FACILITYID = fac_id;
-- 		END IF;
-- 	commit;
--  END;
--  /

-- CREATE OR REPLACE TRIGGER RPUD.resetflushingMH_status
--  BEFORE INSERT ON RPUD.D81268
--  FOR EACH ROW
--  DECLARE
-- 	pragma autonomous_transaction;
-- 	total_ANum number;
-- 	total_DNum number;
-- 	fac_id string(20);
-- 	 BEGIN
-- 		SELECT FACILITYID INTO fac_id FROM RPUD.A81268 WHERE OBJECTID = :NEW.SDE_DELETES_ROW_ID AND ROWNUM=1;
-- 		SELECT COUNT(*) INTO total_ANum FROM RPUD.A81268 WHERE FACILITYID = fac_id;
-- 		SELECT COUNT(*) INTO total_DNum FROM RPUD.D81268 WHERE SDE_DELETES_ROW_ID IN (SELECT DISTINCT OBJECTID FROM RPUD.A81268 WHERE FACILITYID = fac_id);
-- 		IF  total_ANum = total_DNum + 1 THEN
-- 		 	UPDATE RPUD.A71017
-- 		 	SET RPUD.A71017.ISFLUSHED = 0
-- 		 	WHERE RPUD.A71017.FACILITYID = fac_id;
-- 		END IF;
-- 	commit;
--  END;
--  /