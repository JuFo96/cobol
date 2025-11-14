       identification division.
       program-id. upload-db2.

       environment division.
       

       data division.
       working-storage section.
       EXEC SQL INCLUDE SQLCA END-EXEC.
       01 db2inst1 PIC X(8) value "db2inst1".
       01 password PIC x(8) value "password".
       01 Program-pass-fields.
          05 Firstnme         Pic x(30).
       01  var-data pic x(20) value "hello world".
       procedure division.
           display var-data
           EXEC SQL
            CONNECT TO testdb
            USER :db2inst1
            USING :password 
           END-EXEC.
       stop run.
       