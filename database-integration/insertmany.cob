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

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  DBNAME                  PIC X(30) VALUE SPACE.
       01  USERNAME                PIC X(30) VALUE SPACE.
       01  PASSWD                  PIC X(10) VALUE SPACE.
       01  HELLO-TABLE-VARS.
         03 data-message           PIC X(50) VALUE SPACE.
         03 data-status            PIC X(10) VALUE SPACE.
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC sql include SQLCA END-EXEC.

       PROCEDURE DIVISION.
       main-routine.
           DISPLAY "Program started".
           
           MOVE "testdb"  TO DBNAME.
           MOVE "postgres"                    TO USERNAME.
           MOVE SPACE                        TO PASSWD.

           EXEC SQL
               CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN STOP RUN.

           EXEC SQL
               DROP TABLE IF EXISTS testtable
           end-exec.

           IF SQLCODE NOT = ZERO PERFORM ERROR-RTN.

           EXEC SQL
               CREATE TABLE orders
               (
                   customer_id    VARCHAR(255),
                   order_date     VARCHAR(255),
                   order_id       VARCHAR(255),
                   order_status   VARCHAR(255),
                   required_date  VARCHAR(255),
                   shipped_date   VARCHAR(255),
                   staff_name     VARCHAR(255),
                   store          VARCHAR(255)
               )
           end-exec.
           perform varying idx 1 by 1 until idx > length
           EXEC SQL
               INSERT INTO orders VALUES (:MSG)
           end-exec.
           IF  SQLCODE NOT = ZERO PERFORM ERROR-RTN.

           EXEC SQL COMMIT WORK END-EXEC.
           
      *    DISCONNECT
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
           
      *    END
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
                 EXEC SQL
                     ROLLBACK
                 END-EXEC
              WHEN  OTHER
                 DISPLAY "Undefined error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
           END-EVALUATE.
      ******************************************************************  
