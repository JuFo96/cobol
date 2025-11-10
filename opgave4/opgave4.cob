       identification division.
       program-id. HELLO.

       data division.
              working-storage section.
              01 customer-info.
                     02 customer-id PIC X(10).
                     02 first-name PIC X(20).
                     02 last-name PIC X(20).
                     02 account-info.
                            03 account-number PIC X(20).
                            03 balance PIC 9(7)V99.
                            03 valutacode PIC X(3).

       procedure division.
           move "1234567890" to customer-id.
           move "Lars" to first-name.
           move "Hansen" to last-name.
           move "DK12345678912345" to account-number.
           move 2500.75 to balance.
           move "DKK" to valutacode.


           display "Kunde-ID: " customer-id.
           display "Fornavn og efternavn: " first-name " " last-name.
           display "Kontonummer: " account-number.  
           display "balance og valutakode: " balance ' ' valutacode.

           display "------AFTER------".
           display "Info" customer-info.
       stop run.
       