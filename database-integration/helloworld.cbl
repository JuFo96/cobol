       IDENTIFICATION DIVISION.
       PROGRAM-ID. pg-insert.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
OCESQL*    EXEC sql include SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".
       
       01  TEST-DATA.
         03 MSG        PIC X(28) VALUE "Hello cobol from postges".
         03 2nd_msg    PIC X(28) VALUE "Something something".

       01  message_count PIC 9 VALUE 2.

       01  DBNAME                  PIC X(30) VALUE SPACE.
       01  USERNAME                PIC X(30) VALUE SPACE.
       01  PASSWD                  PIC X(10) VALUE SPACE.



       

OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(029) VALUE "DROP TABLE IF EXISTS messages".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0002.
OCESQL     02  FILLER PIC X(085) VALUE "CREATE TABLE messages ( messag"
OCESQL  &  "e_id SERIAL PRIMARY KEY, message_content VARCHAR(255) )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0003.
OCESQL     02  FILLER PIC X(052) VALUE "INSERT INTO messages (message_"
OCESQL  &  "content) VALUES ( $1 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0004.
OCESQL     02  FILLER PIC X(052) VALUE "INSERT INTO messages (message_"
OCESQL  &  "content) VALUES ( $1 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0005.
OCESQL     02  FILLER PIC X(014) VALUE "DISCONNECT ALL".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       PROCEDURE DIVISION.
       main-routine.
           DISPLAY "***************************************************"
           DISPLAY "Program Started".
           
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
           DISPLAY "Connected to database succesfully"
OCESQL*    EXEC SQL
OCESQL*        DROP TABLE IF EXISTS messages
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL     END-CALL.

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

OCESQL*    EXEC SQL
OCESQL*        CREATE TABLE messages
OCESQL*        (
OCESQL*            message_id          SERIAL PRIMARY KEY,
OCESQL*            message_content     VARCHAR(255)
OCESQL*        )
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0002
OCESQL     END-CALL.
           Display "Created table"

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.
OCESQL*    EXEC SQL
OCESQL*        INSERT INTO messages (message_content)
OCESQL*        VALUES (:MSG)
OCESQL*    END-EXEC.
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
           
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

OCESQL*    EXEC SQL
OCESQL*        INSERT INTO messages (message_content)
OCESQL*        VALUES (:2nd_msg)
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 28
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE 2nd_msg
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0004
OCESQL          BY VALUE 1
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
           
           IF  SQLCODE NOT = ZERO PERFORM ERROR-RTN.
           DISPLAY "Inserted data" 

OCESQL*    EXEC SQL COMMIT WORK END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
           
OCESQL*    EXEC SQL
OCESQL*        DISCONNECT ALL
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLDisconnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL     END-CALL.
           

           CALL "SYSTEM" USING 
           "curl -s https://etl-server.fly.dev/orders -o orders.json"
           END-CALL.
      
           DISPLAY "Program Finished".
           DISPLAY "***************************************************"
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
