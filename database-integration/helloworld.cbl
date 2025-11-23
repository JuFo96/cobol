       IDENTIFICATION DIVISION.
       PROGRAM-ID. pg-insert.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  TEST-DATA.
         03 MSG PIC X(28) VALUE "Hello cobol from postgres".

       01  TEST-DATA-R REDEFINES TEST-DATA.
         03  WS-TABLE OCCURS 2.
           05 TEST-NUM             PIC S9(04).
           05 TEST-NAME            PIC X(20).
           05 TEST-SALARY          PIC S9(04).

OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  DBNAME                  PIC X(30) VALUE SPACE.
       01  USERNAME                PIC X(30) VALUE SPACE.
       01  PASSWD                  PIC X(10) VALUE SPACE.
       01  HELLO-TABLE-VARS.
         03 data-message           PIC X(50) VALUE SPACE.
         03 data-status            PIC X(10) VALUE SPACE.
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.

OCESQL*EXEC sql include SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(030) VALUE "DROP TABLE IF EXISTS testtable".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0002.
OCESQL     02  FILLER PIC X(043) VALUE "CREATE TABLE testtable ( MSG V"
OCESQL  &  "ARCHAR(255) )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0003.
OCESQL     02  FILLER PIC X(035) VALUE "INSERT INTO testtable VALUES ("
OCESQL  &  " $1 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0004.
OCESQL     02  FILLER PIC X(014) VALUE "DISCONNECT ALL".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       PROCEDURE DIVISION.
       main-routine.
           DISPLAY "Program started".
           
           MOVE "testdb"  TO DBNAME.
           MOVE "postgres"                    TO USERNAME.
           MOVE SPACE                        TO PASSWD.

OCESQL*    EXEC SQL
OCESQL*        CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLConnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE USERNAME
OCESQL          BY VALUE 30
OCESQL          BY REFERENCE PASSWD
OCESQL          BY VALUE 10
OCESQL          BY REFERENCE DBNAME
OCESQL          BY VALUE 30
OCESQL     END-CALL.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN STOP RUN.

OCESQL*    EXEC SQL
OCESQL*        DROP TABLE IF EXISTS testtable
OCESQL*    end-exec.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL     END-CALL.

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

OCESQL*    EXEC SQL
OCESQL*        CREATE TABLE testtable
OCESQL*        (
OCESQL*            MSG    VARCHAR(255)
OCESQL*        )
OCESQL*    end-exec.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0002
OCESQL     END-CALL.
           display MSG
OCESQL*    EXEC SQL
OCESQL*        INSERT INTO testtable VALUES (:MSG)
OCESQL*    end-exec.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 28
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE MSG
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0003
OCESQL          BY VALUE 1
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
           IF  SQLCODE NOT = ZERO PERFORM ERROR-RTN.

OCESQL*    EXEC SQL COMMIT WORK END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
           
      *    DISCONNECT
OCESQL*    EXEC SQL
OCESQL*        DISCONNECT ALL
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLDisconnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL     END-CALL.
           
      *    END
           CALL "SYSTEM" USING 
           "curl -s https://etl-server.fly.dev/orders -o tmp.json"
           END-CALL.
      
           DISPLAY "Program Finished".
           STOP RUN.


       ERROR-RTN.
      ******************************************************************
           DISPLAY "*** SQL ERROR ***".
           DISPLAY "SQLCODE: " SQLCODE " " NO ADVANCING.
           EVALUATE SQLCODE
              WHEN  +10
                 DISPLAY "Record not found"
              WHEN  -01
                 DISPLAY "Connection falied"
              WHEN  -20
                 DISPLAY "Internal error"
              WHEN  -30
                 DISPLAY "PostgreSQL error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
              *> TO RESTART TRANSACTION, DO ROLLBACK.
OCESQL*          EXEC SQL
OCESQL*              ROLLBACK
OCESQL*          END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "ROLLBACK" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
              WHEN  OTHER
                 DISPLAY "Undefined error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
           END-EVALUATE.
      ******************************************************************  
      ******************************************************************  
      ******************************************************************  
