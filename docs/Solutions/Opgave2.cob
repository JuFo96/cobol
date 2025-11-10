       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave2.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *------------------------------------------------------*
      * Variabler                                             *
      *------------------------------------------------------*
       01  KUNDE-ID        PIC X(10)   VALUE SPACES.
       01  FORNAVN         PIC X(20)   VALUE SPACES.
       01  EFTERNAVN       PIC X(20)   VALUE SPACES.
       01  KONTONUMMER     PIC X(20)   VALUE SPACES.
       01  BALANCE         PIC 9(7)V99 VALUE ZEROS.
       01  VALUTAKODE      PIC X(3)    VALUE SPACES.

       PROCEDURE DIVISION.
      *------------------------------------------------------*
      * Tildel værdier til variabler                         *
      *------------------------------------------------------*
           MOVE "K123456789"   TO KUNDE-ID
           MOVE "Morten"       TO FORNAVN
           MOVE "Jensen"       TO EFTERNAVN
           MOVE "DK1234567890" TO KONTONUMMER
           MOVE 12345.67       TO BALANCE
           MOVE "DKK"          TO VALUTAKODE

      *------------------------------------------------------*
      * Udskriv værdierne                                   *
      *------------------------------------------------------*
           DISPLAY "----------------------------------------"
           DISPLAY "Kunde ID       : " KUNDE-ID
           DISPLAY "Navn           : " FORNAVN " " EFTERNAVN
           DISPLAY "Kontonummer    : " KONTONUMMER
           DISPLAY "Balance        : " BALANCE " " VALUTAKODE
           DISPLAY "----------------------------------------"

           STOP RUN.
