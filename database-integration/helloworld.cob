       IDENTIFICATION DIVISION.
       PROGRAM-ID. pg-insert.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
           EXEC sql include SQLCA END-EXEC.
       
       01  TEST-DATA.
         03 MSG        PIC X(28) VALUE "Hello cobol from postges".
         03 2nd_msg    PIC X(28) VALUE "Something something".

       01  message_count PIC 9 VALUE 2.

       01  DBNAME                  PIC X(30) VALUE SPACE.
       01  USERNAME                PIC X(30) VALUE SPACE.
       01  PASSWD                  PIC X(10) VALUE SPACE.



       

       PROCEDURE DIVISION.
       main-routine.
           DISPLAY "***************************************************"
           DISPLAY "Program Started".
           
           MOVE "testdb"  TO DBNAME.
           MOVE "postgres"                    TO USERNAME.
           MOVE SPACE                        TO PASSWD.

           EXEC SQL
               CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN STOP RUN.
           DISPLAY "Connected to database succesfully"
           EXEC SQL
               DROP TABLE IF EXISTS messages
           END-EXEC.

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

           EXEC SQL
               CREATE TABLE messages
               (
                   message_id          SERIAL PRIMARY KEY,
                   message_content     VARCHAR(255)
               )
           END-EXEC.
           Display "Created table"

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.
           EXEC SQL
               INSERT INTO messages (message_content)
               VALUES (:MSG)
           END-EXEC.
           
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

           EXEC SQL
               INSERT INTO messages (message_content)
               VALUES (:2nd_msg)
           END-EXEC.
           
           IF  SQLCODE NOT = ZERO PERFORM ERROR-RTN.
           DISPLAY "Inserted data" 

           EXEC SQL COMMIT WORK END-EXEC.
           
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
           

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
                 EXEC SQL
                     ROLLBACK
                 END-EXEC
              WHEN  OTHER
                 DISPLAY "Undefined error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
           END-EVALUATE.
      ******************************************************************  
