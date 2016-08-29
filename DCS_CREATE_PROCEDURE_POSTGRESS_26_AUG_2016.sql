

-------------------------------------PROCEDURE------------------------
----------------(1)------------------getuserinfo----------------------




CREATE OR REPLACE FUNCTION getuserinfo(
IN i_user_logname character varying, 
OUT x_id character varying, 
OUT x_loginname character varying, 
OUT x_lastname character varying,
 OUT x_firstname character varying, 
 OUT x_email character varying, 
 OUT x_locale character varying, 
 OUT x_status numeric, 
 OUT x_acct_expired character varying, 
 OUT x_credentials_expired character varying, 
 OUT x_iisinternal character varying,
 OUT x_acct_locked character varying, 
 OUT x_lastbadlogin date,
 OUT x_badlogincount numeric,
 OUT x_passwordchangeddate date,
 OUT x_lastlogindate date, 
 OUT x_phonenumber character varying, 
 OUT x_question_id numeric, 
 OUT x_question_answer character varying,
 OUT x_created_by numeric, 
 OUT x_created_date timestamp without time zone,
 OUT x_modified_by numeric, 
 OUT x_modified_date timestamp without time zone, 
 OUT x_password character varying, 
 OUT x_pwd_change_type character varying,
 OUT x_entity_id numeric, 
 OUT x_role_name character varying, 
 OUT x_subrole_name character varying,
 OUT x_is_logged_in character varying, 
 OUT x_error_code character varying, 
 OUT x_error_msg character varying)
RETURNS record AS
$BODY$ 
 DECLARE

  -- *****************************************************************
  -- Description: Returns  user details for given logged in user
  -- Input Parameters: Refer parameter list (i.e. parameters starts with I_<Name>)
  -- Output Parameters: Refer parameter list (i.e. parameters starts with O_<Name>)
  -- Error Conditions Raised: sql exceptions and no data found exception
  -- Author:      Sravan Kumar
  -- Revision History
  -- Date            Author        Reason for Change
  -- ----------------------------------------------------------------
  --26 AUG 2016     Sushreesmita  Created.
  -- *****************************************************************
 X_APPEND_INPUT  character varying(4000);
 V1   character varying(4000);                
 X_USER_LOCKED  character varying(4000);
 X_USER_EXPIRED  character varying(4000);       
 X_USER_CREDENTIALS_EXPIRED character varying(4000);
        x_acct_locked_dummy         character varying(4000);
 X_ACTIVE_STATUS   NUMERIC;
 X_MER_STATUS                NUMERIC;
 --USER_ACC_LOCKED             EXCEPTION;
 --USER_ACC_EXPIRED            EXCEPTION;
 --USER_CREDENTIALS_EXPIRED    EXCEPTION;
        X_PHONE_NO              VARCHAR(255)=NULL;

BEGIN


 X_ACTIVE_STATUS := STATUS_VALUE('ACTIVE','ALL');
  X_PHONE_NO:=GET_MOBILE_NO(i_user_logname);
  if(X_PHONE_NO IS NOT NULL) THEN
  
  SELECT 
         CSU.USER_ID,
         CSU.MOBILE_NO,
         CSUP.LAST_NAME,
         CSUP.FIRST_NAME,
         CSU.EMAIL_ID,
         CSUP.STATUS,
         CSU.ISLOCKED,
        CSU.MOBILE_NO,
         CSU.PASS_CODE,
         CSU.ISLOGIN,
         'ROLE_SYSTEM_ADMIN' as ROLE_NAME,
         'MANAGER' as SUBROLE_NAME,
         'F' as USR_ACCT_LOCKED,
         'F' as USR_CREDENTIALS_EXPIRED,
         'F' as USR_ACCT_EXPIRED
     INTO    
          X_ID ,
          X_LOGINNAME , 
          X_LASTNAME ,
          X_FIRSTNAME ,
          X_EMAIL ,
          X_STATUS ,
          X_ACCT_LOCKED , 
          X_PHONENUMBER , 
          X_PASSWORD , 
          X_IS_LOGGED_IN,
          X_ROLE_NAME,
          X_SUBROLE_NAME,
          X_ACCT_LOCKED,
          X_CREDENTIALS_EXPIRED,
          X_ACCT_EXPIRED
     FROM users_info CSU,users_profile CSUP
     WHERE CSU.USER_ID=CSUP.USER_ID
     AND CSU.MOBILE_NO=i_user_logname;
     
     IF(X_ACCT_LOCKED ='Y') THEN
   RAISE EXCEPTION USING ERRCODE='2000';
 END IF;
  
   ELSE   
                    SELECT
                            U.USR_ID, 
                            U.USR_LOGINNAME, 
                            U.USR_LASTNAME, 
                            U.USR_FIRSTNAME,
                            U.USR_EMAIL,
                            U.USR_LOCALE, 
                            U.STATUS,
                            U.USR_ACCT_EXPIRED, 
                            U.USR_CREDENTIALS_EXPIRED, 
                            U.ISINTERNAL, 
                            U.USR_ACCT_LOCKED, 
                            U.LASTBADLOGIN, 
                            U.BADLOGINCOUNT, 
                            U.PASSWORDCHANGEDDATE, 
                            U.LASTLOGINDATE,
                            U.PHONE_NUMBER , 
                            U.SECURITY_QUESTION_ID ,
                            U.SECURITY_QUESTION_ANSWER ,
                            U.CREATED_BY , 
                            U.CREATED_DATE , 
                            U.MODIFIED_BY ,
                            U.MODIFIED_DATE ,
                            U.PASSWORD ,
                            U.ENTITY_ID, 
                            U.PWD_CHANGE_TYPE,
                            ROL.ROLE_NAME , 
                            ROL.SUBROLE_NAME,
                            u.isloggedin
                    INTO 
                            X_ID ,
                            X_LOGINNAME , 
                            X_LASTNAME ,
                            X_FIRSTNAME ,
                            X_EMAIL ,
                            X_LOCALE , 
                            X_STATUS ,
                            X_ACCT_EXPIRED , 
                            X_CREDENTIALS_EXPIRED , 
                            X_IISINTERNAL , 
                            X_ACCT_LOCKED , 
                            X_LASTBADLOGIN , 
                            X_BADLOGINCOUNT , 
                            X_PASSWORDCHANGEDDATE , 
                            X_LASTLOGINDATE , 
                            X_PHONENUMBER , 
                            X_QUESTION_ID , 
                            X_QUESTION_ANSWER , 
                            X_CREATED_BY , 
                            X_CREATED_DATE , 
                            X_MODIFIED_BY , 
                            X_MODIFIED_DATE , 
                            X_PASSWORD , 
                            X_ENTITY_ID, 
                            X_PWD_CHANGE_TYPE,
                            X_ROLE_NAME , 
                            X_SUBROLE_NAME,
                            X_IS_LOGGED_IN
                  
                    FROM 
                        USERS U, userrolegrp UROLE, roles ROL, role_groups RG
                    WHERE 
                        U.USR_ID       = UROLE.USER_ID
                        AND UROLE.ROLEGRP_ID = RG.ROLEGROUP_ID
                        AND RG.ROLE_ID       =ROL.ROLE_ID
                        AND U.STATUS         = X_ACTIVE_STATUS
                        AND UROLE.STATUS     = X_ACTIVE_STATUS
                        AND ROL.STATUS       = X_ACTIVE_STATUS
                        AND RG.STATUS        = X_ACTIVE_STATUS 
                        AND UPPER(U.USR_LOGINNAME)  = UPPER(I_USER_LOGNAME);
                        
                          X_USER_LOCKED             := X_ACCT_LOCKED;
                      X_USER_EXPIRED            := X_ACCT_EXPIRED;
                      X_USER_CREDENTIALS_EXPIRED:=X_CREDENTIALS_EXPIRED;
                      
                    IF(X_MER_STATUS=9376609 ) THEN
                        X_ACCT_LOCKED:='T';
                        X_USER_LOCKED             := X_ACCT_LOCKED;
                        
                       RAISE EXCEPTION USING ERRCODE='2000';
                      END IF;
                       
                    IF(X_USER_LOCKED ='T') THEN
                        RAISE EXCEPTION 'USER_ACC_LOCKED';
                        RAISE EXCEPTION USING ERRCODE='20001';
                    END IF;
                  
                     IF( X_MER_STATUS=9376608) then 
                     X_ACCT_EXPIRED:='T';
                     X_USER_EXPIRED            := X_ACCT_EXPIRED;
                     RAISE EXCEPTION USING ERRCODE='22022';
                     end if;
                     
                    IF(X_USER_EXPIRED='T') THEN
                        
                        RAISE EXCEPTION USING
           ERRCODE='22022';
                    END IF;
                        
                    IF(X_USER_CREDENTIALS_EXPIRED='T') THEN
                        RAISE EXCEPTION USING ERRCODE='23033';
                    END IF;
 END IF;       
  
 
 
 --EXCEPTION
 --WHEN USER_ACC_LOCKED THEN
 
 --X_APPEND_INPUT := I_USER_LOGNAME;
 --X_ERROR_CODE := 2000;
 --X_ERROR_MSG := 'Account Locked';
 EXCEPTION
 WHEN  SQLSTATE '20001'  THEN
 X_APPEND_INPUT := I_USER_LOGNAME;
 X_ERROR_CODE   := 2000;
 X_ERROR_MSG := 'Account Locked';
 INSERT
 INTO ERRORS
 (
  ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
 )
 VALUES
 (
  ERRORS_SEQ.NEXTVAL, X_ERROR_CODE, X_ERROR_MSG, CURRENT_TIMESTAMP, 'GETUSERINFO', X_APPEND_INPUT
 )
 RETURNING ERROR_ID INTO V1;
 /* COMMIT; */
 --WHEN USER_ACC_EXPIRED THEN
 WHEN SQLSTATE '22022'  THEN
 X_APPEND_INPUT := I_USER_LOGNAME;
 X_ERROR_CODE   := 2001;
 X_ERROR_MSG := 'Account Expired';

 INSERT
 INTO ERRORS
 (
  ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
 )
 VALUES
 (
  ERRORS_SEQ.NEXTVAL, X_ERROR_CODE, X_ERROR_MSG, CURRENT_TIMESTAMP, 'GETUSERINFO', X_APPEND_INPUT
 )
 RETURNING ERROR_ID INTO V1;
/* COMMIT; */
 --WHEN  USER_CREDENTIALS_EXPIRED  THEN
 --X_APPEND_INPUT := I_USER_LOGNAME;
 --X_ERROR_CODE   := 2002;
 --X_ERROR_MSG := 'Credentials Expired';

 WHEN  SQLSTATE '23033'  THEN
 X_APPEND_INPUT := I_USER_LOGNAME;
 X_ERROR_CODE   := 2002;
 X_ERROR_MSG := 'Credentials Expired';
 
 
 INSERT
 INTO ERRORS
 (
  ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
 )
 VALUES
 (
  ERRORS_SEQ.NEXTVAL, X_ERROR_CODE, X_ERROR_MSG, CURRENT_TIMESTAMP, 'GETUSERINFO', X_APPEND_INPUT
 )
 RETURNING ERROR_ID INTO V1 ;
 /* COMMIT; */
 WHEN OTHERS THEN
 X_APPEND_INPUT := I_USER_LOGNAME;
 X_ERROR_CODE   := SQLCODE; 
 X_ERROR_MSG := SQLERRM;

 INSERT
 INTO ERRORS
 (
  ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
 )
 VALUES
 (
  ERRORS_SEQ.NEXTVAL, X_ERROR_CODE, X_ERROR_MSG, CURRENT_TIMESTAMP, 'GETUSERINFO', X_APPEND_INPUT
 )
 RETURNING ERROR_ID INTO V1 ;
  /* COMMIT; */
 X_ERROR_MSG := X_ERROR_MSG || 'n ERROR TABLE ID::---' ||V1;
END;
$BODY$ 
 language plpgsql;
 commit;
 
-------------------GETUSERINFO_STATUS-----------------------------------
 -------------(2)------GETUSERINFO_STATUS----------------
 create OR  REPLACE FUNCTION GETUSERINFO_STATUS(
  IN  i_user_logname character varying,
  OUT x_id  character varying,
  OUT x_loginname  character varying,
  OUT x_status  NUMERIC, 
  OUT x_acct_expired  character varying,
  OUT x_credentials_expired  character varying, 
  OUT x_iisinternal  character varying,
  OUT x_acct_locked  character varying,
  OUT x_is_logged_in  character varying, 
  OUT  x_error_code  character varying, 
  OUT x_error_msg  character varying)
 RETURNS record AS
 $BODY$ 
 DECLARE

  -- *****************************************************************
  -- Description: Returns  user details for given logged in user
  -- Input Parameters: Refer parameter list (i.e. parameters starts with I_<Name>)
  -- Output Parameters: Refer parameter list (i.e. parameters starts with O_<Name>)
  -- Error Conditions Raised: sql exceptions and no data found exception
  -- Author:      Sravan Kumar
  -- Revision History
  -- Date            Author        Reason for Change
  -- ----------------------------------------------------------------
  -- 26 AUG 2016     Sushreesmita Created.
  -- *****************************************************************
	X_APPEND_INPUT	character varying(4000);
	V1	 character varying(4000);
        X_PHONE_NO character varying(4000):=NULL;
BEGIN
X_PHONE_NO:=GET_MOBILE_NO(i_user_logname);
if(X_PHONE_NO IS NOT NULL) THEN
                SELECT 
                         CSU.USER_ID,
                         CSU.MOBILE_NO,
                         CSUP.STATUS,
                         CSU.ISLOCKED,            
                         CSU.ISLOGIN
                     INTO    
                          X_ID ,
                          X_LOGINNAME , 
                          X_STATUS ,
                          X_ACCT_LOCKED , 
                          X_IS_LOGGED_IN
                     FROM users_info CSU,users_profile CSUP
                     WHERE CSU.USER_ID=CSUP.USER_ID
                     AND CSU.MOBILE_NO=I_USER_LOGNAME;
ELSE 
        SELECT
                U.USR_ID, 
                U.USR_LOGINNAME, 
                U.STATUS,
                U.USR_ACCT_EXPIRED, 
                U.USR_CREDENTIALS_EXPIRED, 
                U.ISINTERNAL, 
                U.USR_ACCT_LOCKED,  
                U.ISLOGGEDIN
            INTO 
                X_ID ,
                X_LOGINNAME , 
                X_STATUS ,
                X_ACCT_EXPIRED , 
                X_CREDENTIALS_EXPIRED , 
                X_IISINTERNAL , 
                X_ACCT_LOCKED ,    
                X_IS_LOGGED_IN
            FROM 
                USERS U
                WHERE UPPER(U.USR_LOGINNAME)  = UPPER(I_USER_LOGNAME);  
END IF;
            
EXCEPTION	
	WHEN OTHERS THEN
	X_APPEND_INPUT := I_USER_LOGNAME;
	X_ERROR_CODE   := SQLCODE;	
	X_ERROR_MSG := SQLERRM;
	INSERT
	INTO ERRORS
	(
		ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
	)
	VALUES
	(
		ERRORS_SEQ.NEXTVAL, X_ERROR_CODE, X_ERROR_MSG, SYSTIMESTAMP, 'GETUSERINFO_STATUS', X_APPEND_INPUT
	)
	RETURNING ERROR_ID
	INTO V1 ;
	X_ERROR_MSG := X_ERROR_MSG || '\n ERROR TABLE ID::---' ||V1;
END;

$BODY$ 
 language plpgsql;
 commit;
 
 -----------------------------GETGROUPS----------------------
 --------(3)-------------------------------------------------
 create or replace FUNCTION  GETGROUPS (
   IN I_USER_LOGNAME  character varying,
   OUT  GRP_NAMES character varying,
    OUT O_ERROR_CODE  NUMERIC,
   OUT O_ERROR_MSG  character varying)

 RETURNS record AS
 $BODY$ 
 DECLARE

  -- *****************************************************************
  -- Description: Returns Role groups associated to given user name
  --
  -- Input Parameters: Refer parameter list (i.e. parameters starts with I_<Name>)
  --
  -- Output Parameters: Refer parameter list (i.e. parameters starts with O_<Name>)
  --
  -- Error Conditions Raised: sql exceptions and no data found exception
  --
  -- Author:     sushreesmita
  --
  -- Revision History
  -- Date            Author       Reason for Change
  -- ----------------------------------------------------------------
  -- 26 AUG 2016     Sushreesmita dhal        Created.
  -- *****************************************************************
  X_APPEND_INPUT character varying(4000);
  V1             character varying(4000);
  V_GRPNAMES     character varying (4000);
  X_PHONE_NO		 character varying(255):=NULL;

  c1 CURSOR
  IS
    
    SELECT   
			GROUP_NAME
   FROM 
			USERS U, USERROLEGRP UROLE, ROLES ROL, ROLE_GROUPS RG, GROUPS G
	WHERE
			U.USR_ID       = UROLE.USER_ID
			AND UROLE.ROLEGRP_ID = RG.ROLEGROUP_ID
			AND RG.ROLE_ID       =ROL.ROLE_ID
			AND G.GROUP_ID       = RG.GROUP_ID
			AND U.STATUS        IN ( SELECT STATUSMASTER_ID FROM STATUS_MASTER WHERE STATUS='ACTIVE')
			AND UROLE.STATUS IN ( SELECT STATUSMASTER_ID FROM STATUS_MASTER WHERE STATUS='ACTIVE')
			AND ROL.STATUS IN ( SELECT STATUSMASTER_ID FROM STATUS_MASTER WHERE STATUS='ACTIVE' )
			AND RG.STATUS IN ( SELECT STATUSMASTER_ID FROM STATUS_MASTER WHERE STATUS='ACTIVE' )
			AND upper(U.USR_LOGINNAME) =upper(I_USER_LOGNAME);
BEGIN
  X_PHONE_NO:=GET_MOBILE_NO(I_USER_LOGNAME);
  
  if(X_PHONE_NO IS NOT NULL) THEN
          GRP_NAMES  := 'SystemAdmin-Manager';
  ELSE   
              FOR I IN C1
          LOOP
            V_GRPNAMES := V_GRPNAMES || TRIM (I.GROUP_NAME) || ',';
          
          END LOOP;
          V_GRPNAMES := RTRIM (V_GRPNAMES, ', ');
          GRP_NAMES  := V_GRPNAMES;
        
           
  END IF;

EXCEPTION

WHEN OTHERS THEN
  X_APPEND_INPUT := I_USER_LOGNAME;
  O_ERROR_CODE := SQLCODE;
  O_ERROR_MSG := SQLERRM;
  
  INSERT
    INTO ERRORS
      (
        ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
      )
      VALUES
      (
        ERRORS_SEQ.NEXTVAL, O_ERROR_CODE, O_ERROR_MSG, SYSTIMESTAMP, 'GETGROUPS', X_APPEND_INPUT
      )
    RETURNING ERROR_ID
    INTO V1 ;
  COMMIT;
  O_ERROR_MSG := O_ERROR_MSG || '\n ERROR TABLE ID::---' ||V1;

END;
$BODY$ 
LANGUAGE plpgsql VOLATILE
  COST 100;


commit;




-------------------GET_PERMISSIONS----------------



--------------(4)------------------------------



create or replace FUNCTION GET_PERMISSIONS (
 IN i_username  character varying,
  OUT O_GETPERMISSIONS  refcursor, 
  o_error_code OUT character varying,
  o_error_msg OUT character varying)
 RETURNS record AS
$BODY$  
	 DECLARE 
  X_APPEND_INPUT character varying(4000);
  V1             character varying(4000);
  X_PHONE_NO		character varying:=NULL;
BEGIN
X_PHONE_NO:=GET_MOBILE_NO(i_username);
if(X_PHONE_NO IS NOT NULL) THEN

OPEN O_GETPERMISSIONS FOR
           SELECT 
               P1.PERMISSION_ID,PERMISSION_NAME AS COMPONENT,
              (SELECT P2.PERMISSION_NAME FROM PERMISSIONS P2 WHERE P1.PARENT_ID= P2.PERMISSION_ID) AS FUNCTIONALITY,
              (SELECT P3.PERMISSION_NAME FROM PERMISSIONS P3 WHERE P3.PERMISSION_ID IN (SELECT P4.PARENT_ID FROM PERMISSIONS P4 WHERE 
                        P1.PARENT_ID= P4.PERMISSION_ID )) AS MENULINK,
              (SELECT P3.SEQ FROM PERMISSIONS P3 WHERE P3.PERMISSION_ID IN (SELECT P4.PARENT_ID FROM PERMISSIONS P4 WHERE P1.PARENT_ID= 
                        P4.PERMISSION_ID )) AS MENUSEQ,
              (SELECT P5.PERMISSION_DESCRIPTION FROM PERMISSIONS P5 WHERE P5.PERMISSION_ID
                        IN (SELECT P6.PARENT_ID FROM PERMISSIONS P6 WHERE P1.PARENT_ID= P6.PERMISSION_ID)) AS DESCRIPTION
            FROM 
              PERMISSIONS P1
            WHERE 
                P1.STATUS = STATUS_VALUE('ACTIVE','ALL')
                AND P1.permission_id in
                  (select PERMISSION_ID from ROLE_GROUP_PERMISSION where ROLE_GROUP_ID=100011
                  and STATUS = STATUS_VALUE('ACTIVE','ALL'))
                ORDER BY MENUSEQ;
else

OPEN O_GETPERMISSIONS FOR
           SELECT 
               P1.PERMISSION_ID,PERMISSION_NAME AS COMPONENT,
              (SELECT P2.PERMISSION_NAME FROM PERMISSIONS P2 WHERE P1.PARENT_ID= P2.PERMISSION_ID) AS FUNCTIONALITY,
              (SELECT P3.PERMISSION_NAME FROM PERMISSIONS P3 WHERE P3.PERMISSION_ID IN (SELECT P4.PARENT_ID FROM PERMISSIONS P4 WHERE 
                        P1.PARENT_ID= P4.PERMISSION_ID )) AS MENULINK,
              (SELECT P3.SEQ FROM PERMISSIONS P3 WHERE P3.PERMISSION_ID IN (SELECT P4.PARENT_ID FROM PERMISSIONS P4 WHERE P1.PARENT_ID= 
                        P4.PERMISSION_ID )) AS MENUSEQ,
              (SELECT P5.PERMISSION_DESCRIPTION FROM PERMISSIONS P5 WHERE P5.PERMISSION_ID
                        IN (SELECT P6.PARENT_ID FROM PERMISSIONS P6 WHERE P1.PARENT_ID= P6.PERMISSION_ID)) AS DESCRIPTION
            FROM 
              PERMISSIONS P1
            WHERE 
                P1.STATUS = STATUS_VALUE('ACTIVE','ALL')
                AND P1.permission_id in
                  (select PERMISSION_ID from  ROLE_GROUP_PERMISSION where ROLE_GROUP_ID
                    IN (SELECT ROLEGRP_ID FROM USERROLEGRP WHERE USER_ID IN ( SELECT USR_ID FROM USERS WHERE 
                    UPPER(USR_LOGINNAME) = UPPER(I_USERNAME) and isloggedin='Y'))
                  and STATUS = STATUS_VALUE('ACTIVE','ALL'))
                ORDER BY MENUSEQ;
end if;
  
	IF NOT O_GETPERMISSIONS%FOUND THEN
		RAISE NO_DATA_FOUND;
    END IF;
	
EXCEPTION
WHEN  NO_DATA_FOUND  THEN
  O_ERROR_CODE := SQLCODE;
  O_ERROR_MSG := SQLERRM;
  INSERT
    INTO ERRORS
      (
        ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
      )
      VALUES
      (
       ERRORS_SEQ.NEXTVAL, O_ERROR_CODE, O_ERROR_MSG, SYSTIMESTAMP, 'GET_PERMISSIONS', 'NONE'
      )
      	RETURNING ERROR_ID	INTO V1 ;    
COMMIT;
  O_ERROR_MSG := O_ERROR_MSG || '\n ERROR TABLE ID::---' ||V1;
WHEN OTHERS THEN
  O_ERROR_CODE := SQLCODE;
  O_ERROR_MSG := SQLERRM;
  INSERT
    INTO ERRORS
      (
        ERROR_ID, CODE, MESSAGE, HAPPENED, PROCEDURENAME, INPUT_PARAMS
      )
      VALUES
      (
        ERRORS_SEQ.NEXTVAL, O_ERROR_CODE, O_ERROR_MSG, SYSTIMESTAMP, 'GET_PERMISSIONS', I_USERNAME
      )
    	RETURNING ERROR_ID INTO V1 ;
      COMMIT;
  O_ERROR_MSG := O_ERROR_MSG || '\n ERROR TABLE ID::---' ||V1;
RETURN;
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  commit;
 
 
 
 
