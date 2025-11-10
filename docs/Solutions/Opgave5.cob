       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave5.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * --------------------------------------------------
      * Kundeoplysninger via copybook
      * --------------------------------------------------
           01 KUNDEOPL-01.
               COPY "KUNDEOPL.cpy".
           01 KUNDEOPL-02.
               COPY "KUNDEOPL.cpy".

      * --------------------------------------------------
      * Beregnede felter udenfor strukturen
      * --------------------------------------------------
           01 FULDT-NAVN-01       PIC X(40) VALUE SPACES.
           01 RENS-FULDT-NAVN-01  PIC X(40) VALUE SPACES.
           01 FULDT-NAVN-02       PIC X(40) VALUE SPACES.
           01 RENS-FULDT-NAVN-02  PIC X(40) VALUE SPACES.
           01 IX                  PIC 9(2) VALUE 1.
           01 IX2                 PIC 9(2) VALUE 0.
           01 CURRENT-CHAR        PIC X(1) VALUE SPACE.
           01 PREVIOUS-CHAR       PIC X(1) VALUE SPACE.

       PROCEDURE DIVISION.

      * --------------------------------------------------
      * Fyld data i kunde 1
      * --------------------------------------------------
           MOVE "K123456789"   TO KUNDE-ID OF KUNDEOPL-01
           MOVE "Michael B"    TO FORNAVN OF NAVN OF KUNDEOPL-01
           MOVE "Nielsen"      TO EFTERNAVN OF NAVN OF KUNDEOPL-01
           MOVE "DK0987654321" TO KONTONUMMER OF KONTOINFO OF 
                                  KUNDEOPL-01
           MOVE 98765.43       TO BALANCE OF KONTOINFO OF KUNDEOPL-01
           MOVE "DKK"          TO VALUTAKODE OF KONTOINFO OF KUNDEOPL-01
           MOVE "Vejnavn"      TO VEJNAVN OF ADDRESSE OF KUNDEOPL-01
           MOVE "12A"          TO HUSNR OF ADDRESSE OF KUNDEOPL-01
           MOVE "1"            TO ETAGE OF ADDRESSE OF KUNDEOPL-01
           MOVE "Th"           TO SIDE OF ADDRESSE OF KUNDEOPL-01
           MOVE "København"    TO BY-X OF ADDRESSE OF KUNDEOPL-01
           MOVE "2100"         TO POSTNR OF ADDRESSE OF KUNDEOPL-01
           MOVE "DK"           TO LANDE-KODE OF ADDRESSE OF KUNDEOPL-01
           MOVE "12345678"     TO TELEFON OF KONTAKTINFO OF KUNDEOPL-01
           MOVE "michael@nielsen.dk" TO EMAIL OF KONTAKTINFO OF 
                                        KUNDEOPL-01

      * --------------------------------------------------
      * Fyld data i kunde 2
      * --------------------------------------------------
           MOVE "K987654321"   TO KUNDE-ID OF KUNDEOPL-02
           MOVE "Anna"         TO FORNAVN OF NAVN OF KUNDEOPL-02
           MOVE "Jensen"       TO EFTERNAVN OF NAVN OF KUNDEOPL-02
           MOVE "DK1234567890" TO KONTONUMMER OF KONTOINFO OF 
                                  KUNDEOPL-02
           MOVE 54321.99       TO BALANCE OF KONTOINFO OF KUNDEOPL-02
           MOVE "DKK"          TO VALUTAKODE OF KONTOINFO OF KUNDEOPL-02
           MOVE "Andersensvej" TO VEJNAVN OF ADDRESSE OF KUNDEOPL-02
           MOVE "7B"           TO HUSNR OF ADDRESSE OF KUNDEOPL-02
           MOVE "2"            TO ETAGE OF ADDRESSE OF KUNDEOPL-02
           MOVE "Tv"           TO SIDE OF ADDRESSE OF KUNDEOPL-02
           MOVE "Aarhus"       TO BY-X OF ADDRESSE OF KUNDEOPL-02
           MOVE "8000"         TO POSTNR OF ADDRESSE OF KUNDEOPL-02
           MOVE "DK"           TO LANDE-KODE OF ADDRESSE OF KUNDEOPL-02
           MOVE "87654321"     TO TELEFON OF KONTAKTINFO OF KUNDEOPL-02
           MOVE "anna.jensen@mail.dk" TO EMAIL OF KONTAKTINFO OF 
                                      KUNDEOPL-02

      * --------------------------------------------------
      * Sammensæt fuldt navn og rens mellemrum (kunde 1)
      * --------------------------------------------------
           STRING FORNAVN OF NAVN OF KUNDEOPL-01 DELIMITED BY SIZE
                  " " DELIMITED BY SIZE
                  EFTERNAVN OF NAVN OF KUNDEOPL-01 DELIMITED BY SIZE
             INTO FULDT-NAVN-01

           END-STRING

           MOVE SPACE TO RENS-FULDT-NAVN-01
           MOVE 1     TO IX
           MOVE 0     TO IX2
           MOVE SPACE TO PREVIOUS-CHAR

           PERFORM VARYING IX FROM 1 BY 1
               UNTIL IX > LENGTH OF FULDT-NAVN-01
               MOVE FULDT-NAVN-01(IX:1) TO CURRENT-CHAR
               IF CURRENT-CHAR NOT = SPACE
                  OR PREVIOUS-CHAR NOT = SPACE
                  ADD 1 TO IX2
                  MOVE CURRENT-CHAR TO RENS-FULDT-NAVN-01(IX2:1)
               END-IF
               MOVE CURRENT-CHAR TO PREVIOUS-CHAR
           END-PERFORM

      * --------------------------------------------------
      * Sammensæt fuldt navn og rens mellemrum (kunde 2)
      * --------------------------------------------------
           STRING FORNAVN OF NAVN OF KUNDEOPL-02 DELIMITED BY SIZE
                  " " DELIMITED BY SIZE
                  EFTERNAVN OF NAVN OF KUNDEOPL-02 DELIMITED BY SIZE
             INTO FULDT-NAVN-02
           END-STRING

           MOVE SPACE TO RENS-FULDT-NAVN-02
           MOVE 1     TO IX
           MOVE 0     TO IX2
           MOVE SPACE TO PREVIOUS-CHAR

           PERFORM VARYING IX FROM 1 BY 1
               UNTIL IX > LENGTH OF FULDT-NAVN-02
               MOVE FULDT-NAVN-02(IX:1) TO CURRENT-CHAR
               IF CURRENT-CHAR NOT = SPACE
                  OR PREVIOUS-CHAR NOT = SPACE
                  ADD 1 TO IX2
                  MOVE CURRENT-CHAR TO RENS-FULDT-NAVN-02(IX2:1)
               END-IF
               MOVE CURRENT-CHAR TO PREVIOUS-CHAR
           END-PERFORM

      * --------------------------------------------------
      * Display kunde 1
      * --------------------------------------------------
           DISPLAY "---------------- Kunde 1 ---------------"
           DISPLAY "Kunde ID       : " KUNDE-ID OF KUNDEOPL-01
           DISPLAY "Navn (renset)  : " RENS-FULDT-NAVN-01
           DISPLAY "Kontonummer    : " KONTONUMMER OF KONTOINFO OF 
                                       KUNDEOPL-01
           DISPLAY "Balance        : " BALANCE OF KONTOINFO OF 
                                       KUNDEOPL-01 " " VALUTAKODE OF 
                                       KONTOINFO OF KUNDEOPL-01
           DISPLAY "Adresse        : " VEJNAVN OF ADDRESSE OF 
                                       KUNDEOPL-01 " " 
                                   HUSNR OF ADDRESSE OF KUNDEOPL-01 ", " 
                                    ETAGE OF ADDRESSE OF KUNDEOPL-01 
                                    SIDE OF ADDRESSE OF KUNDEOPL-01
           DISPLAY "By/Postnr      : " BY-X OF ADDRESSE OF KUNDEOPL-01 
                                     " " 
                                      POSTNR OF ADDRESSE OF KUNDEOPL-01
           DISPLAY "Telefon/Email  : " TELEFON OF KONTAKTINFO OF 
                                       KUNDEOPL-01 " " EMAIL OF 
                                       KONTAKTINFO OF KUNDEOPL-01

      * --------------------------------------------------
      * Display kunde 2
      * --------------------------------------------------
           DISPLAY "---------------- Kunde 2 ---------------"
           DISPLAY "Kunde ID       : " KUNDE-ID OF KUNDEOPL-02
           DISPLAY "Navn (renset)  : " RENS-FULDT-NAVN-02
           DISPLAY "Kontonummer    : " KONTONUMMER OF KONTOINFO OF 
                                       KUNDEOPL-02
           DISPLAY "Balance        : " BALANCE OF KONTOINFO OF 
                                       KUNDEOPL-02 " " VALUTAKODE OF 
                                       KONTOINFO OF KUNDEOPL-02
           DISPLAY "Adresse        : " VEJNAVN OF ADDRESSE OF 
                                       KUNDEOPL-02 " " 
                                   HUSNR OF ADDRESSE OF KUNDEOPL-02 ", " 
                                   ETAGE OF ADDRESSE OF KUNDEOPL-02 
                                   SIDE OF ADDRESSE OF KUNDEOPL-02
           DISPLAY "By/Postnr      : " BY-X OF ADDRESSE OF KUNDEOPL-02 
                                     " " 
                                      POSTNR OF ADDRESSE OF KUNDEOPL-02
           DISPLAY "Telefon/Email  : " TELEFON OF KONTAKTINFO OF 
                                       KUNDEOPL-02 " " EMAIL OF 
                                       KONTAKTINFO OF KUNDEOPL-02

           STOP RUN.
