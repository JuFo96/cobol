       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave3.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * --------------------------------------------------
      * Oprindelige variabler
      * --------------------------------------------------
           01  KUNDE-ID           PIC X(10)   VALUE SPACES.
           01  FORNAVN            PIC X(20)   VALUE SPACES.
           01  EFTERNAVN          PIC X(20)   VALUE SPACES.
           01  KONTONUMMER        PIC X(20)   VALUE SPACES.
           01  BALANCE            PIC 9(7)V99 VALUE ZEROS.
           01  VALUTAKODE         PIC X(3)    VALUE SPACES.

      * --------------------------------------------------
      * Variabler til fuldt navn og renset output
      * --------------------------------------------------
           01  FULDT-NAVN         PIC X(40)   VALUE SPACES.
           01  RENS-FULDT-NAVN    PIC X(40)   VALUE SPACES.

           01  IX                 PIC 9(2)    VALUE 1.
           01  IX2                PIC 9(2)    VALUE 0.
           01  CURRENT-CHAR       PIC X(1)    VALUE SPACE.
           01  PREVIOUS-CHAR      PIC X(1)    VALUE SPACE.

       PROCEDURE DIVISION.
      * --------------------------------------------------
      * Flyt data til kundeinfo
      * --------------------------------------------------
           MOVE "K123456789"      TO KUNDE-ID
           MOVE "Michael B"       TO FORNAVN
           MOVE "Nielsen"         TO EFTERNAVN
           MOVE "DK0987654321"    TO KONTONUMMER
           MOVE 98765.43          TO BALANCE
           MOVE "DKK"             TO VALUTAKODE

      * --------------------------------------------------
      * Sammensæt fornavn og efternavn til fuldt navn
      * --------------------------------------------------
           STRING FORNAVN DELIMITED BY SIZE
                  " "    DELIMITED BY SIZE
                  EFTERNAVN DELIMITED BY SIZE
             INTO FULDT-NAVN
           END-STRING

      * --------------------------------------------------
      * Vis fuldt navn før løkke
      * --------------------------------------------------
           DISPLAY "FOER LOOP (FULDT-NAVN) : [" FULDT-NAVN "]"

      * --------------------------------------------------
      * Loop for at fjerne ekstra mellemrum
      * --------------------------------------------------
           MOVE SPACE TO RENS-FULDT-NAVN
           MOVE 1     TO IX
           MOVE 0     TO IX2
           MOVE SPACE TO PREVIOUS-CHAR

           PERFORM VARYING IX FROM 1 BY 1
               UNTIL IX > LENGTH OF FULDT-NAVN
               MOVE FULDT-NAVN(IX:1) TO CURRENT-CHAR

               IF CURRENT-CHAR NOT = SPACE
                  OR PREVIOUS-CHAR NOT = SPACE
                  ADD 1 TO IX2
                  MOVE CURRENT-CHAR TO RENS-FULDT-NAVN(IX2:1)
               END-IF

               MOVE CURRENT-CHAR TO PREVIOUS-CHAR
           END-PERFORM.

      * --------------------------------------------------
      * Vis fuldt navn efter loop
      * --------------------------------------------------
           DISPLAY "EFTER LOOP (RENS-FULDT-NAVN) : [" 
                    RENS-FULDT-NAVN "]"

      * --------------------------------------------------
      * Udskriv resultat sammen med øvrige kundeinfo
      * --------------------------------------------------
           DISPLAY "----------------------------------------"
           DISPLAY "Kunde ID       : " KUNDE-ID
           DISPLAY "Navn (renset)  : " RENS-FULDT-NAVN
           DISPLAY "Kontonummer    : " KONTONUMMER
           DISPLAY "Balance        : " BALANCE " " VALUTAKODE
           DISPLAY "----------------------------------------"

           STOP RUN.
