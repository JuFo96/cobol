       identification division.
       program-id. HELLO.

       data division.
              working-storage section.
              01 customer-info-01.
               copy "kunder.cpy".
              01 customer-info-02.
               copy "kunder.cpy".

       procedure division.
           move "1234567890" to customer-id in customer-info-01.
           move "1111111111" to customer-id in customer-info-02.
           move "Lars" to first-name in customer-info-01.


           display "Kunde-ID 1: " customer-id in customer-info-01.
           display "Kunde-ID 2: " customer-id in customer-info-02.


           display "------AFTER------".
           display first-name of customer-info-01.
       stop run.
       