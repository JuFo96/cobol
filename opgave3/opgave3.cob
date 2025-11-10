       identification division.
       program-id. HELLO.

       data division.
       working-storage section.
       01 customer-id PIC X(10).
       01 first-name PIC X(20).
       01 last-name PIC X(20).
       01 full-name PIC X(40).
       01 account-number PIC X(20).
       01 balance PIC S9(6)V9(2).
       01 valutacode PIC X(3).
       
       01 character-index PIC S9(2).
       01 previous-character-index PIC S9(2).

       01 clean-name PIC X(40).

       01 clean-name-index PIC S9(2).





       procedure division.     
           move "1234567890" to customer-id.
           move "Lars" to first-name.
           move "Hansen" to last-name.
           move "DK12345678912345" to account-number.
           move 2500.75 to balance.
           move "DKK" to valutacode.

           STRING first-name delimited by size " "
           delimited by size last-name 
           delimited by size
           into full-name

      *    Loops over the length of "full-name" adding characters to new 
      *    "clean-name" if current char is not space 
           perform varying character-index
            from 0 by 1
            until character-index > length of full-name
            IF full-name(character-index:1) NOT = space 
            or full-name(previous-character-index:1) NOT = space
            move full-name(character-index:1) to 
            clean-name(clean-name-index:1)
            add 1 to clean-name-index
            END-IF
            move character-index to previous-character-index
            
           end-perform
           
           display "*-------------------------------------------------*"
           display "Kunde ID      : " customer-id.
           display "Navn (renset) : " clean-name.
           display "Kontonummer   : " account-number.  
           display "Balance       : " balance ' ' valutacode.
           display "*-------------------------------------------------*"
       stop run.
       