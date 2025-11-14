       identification division.
       program-id. upload-db2.

       environment division.
       

       data division.
       working-storage section.
       01  var-data pic x(20) value "hello world".
       procedure division.
           display var-data
       stop run.
       