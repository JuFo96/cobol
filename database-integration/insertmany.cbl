       IDENTIFICATION DIVISION.
       PROGRAM-ID. pg-json-insert.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT JSON-FILE ASSIGN TO "orders.json"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  JSON-FILE.
       01  JSON-RECORD             PIC X(32000).

       WORKING-STORAGE SECTION.
       01  WS-EOF                  PIC X VALUE 'N'.
       01  WS-JSON-DATA            PIC X(100000).
       01  WS-JSON-LENGTH          PIC 9(08) VALUE ZERO.
       01  WS-INSERT-COUNT         PIC 9(05) VALUE ZERO.
       01  WS-BYTE-COUNT           PIC 9(08) VALUE ZERO.
       01  WS-RECORD-LEN           PIC 9(08) VALUE ZERO.
       
      * JSON parsing control
       01  WS-JSON-STATUS          PIC S9(09) COMP VALUE ZERO.
       01  WS-JSON-CODE            PIC S9(09) COMP VALUE ZERO.

       01  ORDER-COUNT             PIC 9(04) VALUE ZERO.
       01  ORDER-IDX               PIC 9(04) VALUE ZERO.

      * Order data structure for JSON parsing (fixed OCCURS)
      * This matches a direct JSON array: [{"customer_id":...},...]
       01  ORDER-ITEM OCCURS 1615 TIMES.
           05 customer_id       PIC X(255).
           05 order_date        PIC X(255).
           05 order_id          PIC X(255).
           05 order_status      PIC X(255).
           05 required_date     PIC X(255).
           05 shipped_date      PIC X(255).
           05 staff_name        PIC X(255).
           05 store             PIC X(255).

OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  DBNAME                  PIC X(30) VALUE SPACE.
       01  USERNAME                PIC X(30) VALUE SPACE.
       01  PASSWD                  PIC X(10) VALUE SPACE.
       
      * SQL variables for insert
       01  SQL-CUSTOMER-ID         PIC X(255) VALUE SPACE.
       01  SQL-ORDER-DATE          PIC X(255) VALUE SPACE.
       01  SQL-ORDER-ID            PIC X(255) VALUE SPACE.
       01  SQL-ORDER-STATUS        PIC X(255) VALUE SPACE.
       01  SQL-REQUIRED-DATE       PIC X(255) VALUE SPACE.
       01  SQL-SHIPPED-DATE        PIC X(255) VALUE SPACE.
       01  SQL-STAFF-NAME          PIC X(255) VALUE SPACE.
       01  SQL-STORE               PIC X(255) VALUE SPACE.
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.

OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(027) VALUE "DROP TABLE IF EXISTS orders".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0002.
OCESQL     02  FILLER PIC X(223) VALUE "CREATE TABLE orders ( customer"
OCESQL  &  "_id VARCHAR(255), order_date VARCHAR(255), order_id VARCHA"
OCESQL  &  "R(255), order_status VARCHAR(255), required_date VARCHAR(2"
OCESQL  &  "55), shipped_date VARCHAR(255), staff_name VARCHAR(255), s"
OCESQL  &  "tore VARCHAR(255) )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0003.
OCESQL     02  FILLER PIC X(014) VALUE "DISCONNECT ALL".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0004.
OCESQL     02  FILLER PIC X(158) VALUE "INSERT INTO orders (customer_i"
OCESQL  &  "d, order_date, order_id, order_status, required_date, ship"
OCESQL  &  "ped_date, staff_name, store) VALUES ( $1, $2, $3, $4, $5, "
OCESQL  &  "$6, $7, $8 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       PROCEDURE DIVISION.
       MAIN-ROUTINE.
           DISPLAY "JSON to PostgreSQL Insert Program Started".
           
      *    CONNECT TO DATABASE
           MOVE "testdb"    TO DBNAME.
           MOVE "postgres"  TO USERNAME.
           MOVE SPACE       TO PASSWD.

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
           IF SQLCODE NOT = ZERO 
               PERFORM ERROR-RTN 
               STOP RUN
           END-IF.

           DISPLAY "Connected to database successfully".

      *    DROP AND CREATE TABLE
OCESQL*    EXEC SQL
OCESQL*        DROP TABLE IF EXISTS orders
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL     END-CALL.

OCESQL*    EXEC SQL
OCESQL*        CREATE TABLE orders
OCESQL*        (
OCESQL*            customer_id    VARCHAR(255),
OCESQL*            order_date     VARCHAR(255),
OCESQL*            order_id       VARCHAR(255),
OCESQL*            order_status   VARCHAR(255),
OCESQL*            required_date  VARCHAR(255),
OCESQL*            shipped_date   VARCHAR(255),
OCESQL*            staff_name     VARCHAR(255),
OCESQL*            store          VARCHAR(255)
OCESQL*        )
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0002
OCESQL     END-CALL.
           
           IF SQLCODE NOT = ZERO 
               PERFORM ERROR-RTN
               STOP RUN
           END-IF.

           DISPLAY "Table created successfully".

      *    READ ENTIRE JSON FILE INTO MEMORY
           PERFORM READ-JSON-FILE.
           
      *    PARSE JSON
           IF WS-JSON-LENGTH > 0
               PERFORM PARSE-JSON-DATA
           ELSE
               DISPLAY "No JSON data read from file"
               STOP RUN
           END-IF.

      *    INSERT ALL ORDERS
           PERFORM INSERT-ALL-ORDERS.

OCESQL*    EXEC SQL COMMIT WORK END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
           
           DISPLAY "Total records inserted: " WS-INSERT-COUNT.
           
      *    DISCONNECT
OCESQL*    EXEC SQL
OCESQL*        DISCONNECT ALL
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLDisconnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL     END-CALL.
           
           DISPLAY "Program Finished Successfully".
           STOP RUN.

       READ-JSON-FILE.
           OPEN INPUT JSON-FILE.
           MOVE ZERO TO WS-JSON-LENGTH.
           MOVE SPACE TO WS-JSON-DATA.

      *    Read entire file into one string (handles single-line JSON)
           PERFORM UNTIL WS-EOF = 'Y'
               READ JSON-FILE INTO JSON-RECORD
                   AT END 
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       PERFORM APPEND-JSON-LINE
               END-READ
           END-PERFORM.

           CLOSE JSON-FILE.
           DISPLAY "JSON file read: " WS-JSON-LENGTH " bytes".

       APPEND-JSON-LINE.
      *    Calculate length of current record
           MOVE FUNCTION LENGTH(
               FUNCTION TRIM(JSON-RECORD TRAILING)) 
               TO WS-RECORD-LEN.
           
      *    Append to main JSON buffer
           IF WS-JSON-LENGTH + WS-RECORD-LEN < 100000
               STRING WS-JSON-DATA(1:WS-JSON-LENGTH)
                      JSON-RECORD(1:WS-RECORD-LEN)
                   DELIMITED BY SIZE
                   INTO WS-JSON-DATA
               END-STRING
               ADD WS-RECORD-LEN TO WS-JSON-LENGTH
           ELSE
               DISPLAY "JSON file too large"
               MOVE 'Y' TO WS-EOF
           END-IF.

       PARSE-JSON-DATA.
           DISPLAY "Parsing JSON data...".
           DISPLAY "First 200 chars: " WS-JSON-DATA(1:200).
           
      *    Parse JSON into COBOL structure
           JSON PARSE WS-JSON-DATA(1:WS-JSON-LENGTH)
               INTO ORDERS-ARRAY
           END-JSON.

           DISPLAY "JSON-STATUS after parse: " JSON-STATUS.

           IF JSON-STATUS NOT = ZERO
               DISPLAY "JSON Parse Error"
               DISPLAY "Status: " JSON-STATUS
               DISPLAY "First 500 chars of JSON:"
               DISPLAY WS-JSON

       INSERT-ALL-ORDERS.
           PERFORM VARYING ORDER-IDX FROM 1 BY 1 
               UNTIL ORDER-IDX > ORDER-COUNT
               
               MOVE customer_id(ORDER-IDX)   TO SQL-CUSTOMER-ID
               MOVE order_date(ORDER-IDX)    TO SQL-ORDER-DATE
               MOVE order_id(ORDER-IDX)      TO SQL-ORDER-ID
               MOVE order_status(ORDER-IDX)  TO SQL-ORDER-STATUS
               MOVE required_date(ORDER-IDX) TO SQL-REQUIRED-DATE
               MOVE shipped_date(ORDER-IDX)  TO SQL-SHIPPED-DATE
               MOVE staff_name(ORDER-IDX)    TO SQL-STAFF-NAME
               MOVE store(ORDER-IDX)         TO SQL-STORE

OCESQL*        EXEC SQL
OCESQL*            INSERT INTO orders 
OCESQL*            (customer_id, order_date, order_id, order_status,
OCESQL*             required_date, shipped_date, staff_name, store)
OCESQL*            VALUES 
OCESQL*            (:SQL-CUSTOMER-ID, :SQL-ORDER-DATE, :SQL-ORDER-ID,
OCESQL*             :SQL-ORDER-STATUS, :SQL-REQUIRED-DATE, 
OCESQL*             :SQL-SHIPPED-DATE, :SQL-STAFF-NAME, :SQL-STORE)
OCESQL*        END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-CUSTOMER-ID
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-ORDER-DATE
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-ORDER-ID
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-ORDER-STATUS
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-REQUIRED-DATE
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-SHIPPED-DATE
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-STAFF-NAME
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE SQL-STORE
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0004
OCESQL          BY VALUE 8
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL

               IF SQLCODE = ZERO
                   ADD 1 TO WS-INSERT-COUNT
                   DISPLAY "Inserted order: " 
                       FUNCTION TRIM(SQL-ORDER-ID)
               ELSE
                   DISPLAY "Failed to insert order: " 
                       FUNCTION TRIM(SQL-ORDER-ID)
                   PERFORM ERROR-RTN
               END-IF
           END-PERFORM.

       ERROR-RTN.
      ******************************************************************
           DISPLAY "*** SQL ERROR ***".
           DISPLAY "SQLCODE: " SQLCODE.
           EVALUATE SQLCODE
              WHEN  +10
                 DISPLAY "Record not found"
              WHEN  -01
                 DISPLAY "Connection failed"
              WHEN  -20
                 DISPLAY "Internal error"
              WHEN  -30
                 DISPLAY "PostgreSQL error"
                 DISPLAY "ERRCODE: "  SQLSTATE
                 DISPLAY SQLERRMC
OCESQL*          EXEC SQL ROLLBACK END-EXEC
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
      ******************************************************************      ******************************************************************      ******************************************************************      ******************************************************************