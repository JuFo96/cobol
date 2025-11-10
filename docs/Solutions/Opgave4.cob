       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave4.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * --------------------------------------------------
      * Struktureret kundeoplysninger
      * --------------------------------------------------
           01 KUNDEOPL.
               02 KUNDE-ID       PIC X(10) VALUE SPACES.
               02 NAVN.
                   03 FORNAVN    PIC X(20) VALUE SPACES.
                   03 EFTERNAVN  PIC X(20) VALUE SPACES.
               02 KONTOINFO.
                   03 KONTONUMMER PIC X(20) VALUE SPACES.
                   03 BALANCE     PIC 9(7)V99 VALUE ZEROS.
                   03 VALUTAKODE  PIC X(3) VALUE SPACES.

      * --------------------------------------------------
      * Beregnede variabler udenfor strukturen
      * --------------------------------------------------
           01 FULDT-NAVN         PIC X(40) VALUE SPACES.
           01 RENS-FULDT-NAVN    PIC X(40) VALUE SPACES.
           01 IX                 PIC 9(2) VALUE 1.
           01 IX2                PIC 9(2) VALUE 0.
           01 CURRENT-CHAR       PIC X(1) VALUE SPACE.
           01 PREVIOUS-CHAR      PIC X(1) VALUE SPACE.

       PROCEDURE DIVISION.
      * --------------------------------------------------
      * Flyt data ind i strukturen
      * --------------------------------------------------
           MOVE "K123456789"   TO KUNDE-ID OF KUNDEOPL
           MOVE "Michael B"    TO FORNAVN OF NAVN OF KUNDEOPL
           MOVE "Nielsen"      TO EFTERNAVN OF NAVN OF KUNDEOPL
           MOVE "DK0987654321" TO KONTONUMMER OF KONTOINFO OF KUNDEOPL
           MOVE 98765.43       TO BALANCE OF KONTOINFO OF KUNDEOPL
           MOVE "DKK"          TO VALUTAKODE OF KONTOINFO OF KUNDEOPL

      * --------------------------------------------------
      * Sammensæt fuldt navn
      * --------------------------------------------------
           STRING FORNAVN OF NAVN OF KUNDEOPL DELIMITED BY SIZE
                  " " DELIMITED BY SIZE
                  EFTERNAVN OF NAVN OF KUNDEOPL DELIMITED BY SIZE
             INTO FULDT-NAVN
           END-STRING

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
      * Vis individuelle felter
      * --------------------------------------------------
           DISPLAY "----------------------------------------"
           DISPLAY "Kunde ID       : " KUNDE-ID OF KUNDEOPL
           DISPLAY "Navn (renset)  : " RENS-FULDT-NAVN
           DISPLAY "Kontonummer    : " KONTONUMMER OF KONTOINFO OF 
                                       KUNDEOPL
           DISPLAY "Balance        : " BALANCE OF KONTOINFO OF KUNDEOPL 
                                     " " 
                                     VALUTAKODE OF KONTOINFO OF KUNDEOPL
           DISPLAY "----------------------------------------"

      * --------------------------------------------------
      * Vis hele strukturen på 01-niveau
      * --------------------------------------------------
           DISPLAY "HELE STRUKTUREN:"
           DISPLAY KUNDEOPL

           STOP RUN.
