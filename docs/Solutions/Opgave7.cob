       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave7.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT KUNDEFIL-IN ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT KUNDEFIL-OUT ASSIGN TO "KundeoplysningerOut.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  KUNDEFIL-IN.
       01  KUNDE-REKORD-IN.
           COPY "KUNDEOPL.cpy".

       FD  KUNDEFIL-OUT.
       01  KUNDE-ADR.
           02  NAVN-ADR          PIC X(100).

       WORKING-STORAGE SECTION.
       01  EOF-FLAG             PIC X VALUE "N".
           88  END-OF-FILE      VALUE "Y".
           88  MORE-TO-READ     VALUE "N".

       01  FULDT-NAVN           PIC X(40) VALUE SPACES.
       01  ADR-LINJE            PIC X(100) VALUE SPACES.
       01  BY-LINJE             PIC X(60) VALUE SPACES.
       01  KONTO-LINJE          PIC X(60) VALUE SPACES.
       01  KONTAKT-LINJE        PIC X(80) VALUE SPACES.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           OPEN INPUT  KUNDEFIL-IN
                OUTPUT KUNDEFIL-OUT

           PERFORM UNTIL END-OF-FILE
               READ KUNDEFIL-IN
                   AT END
                       SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM BEHANDL-KUNDE
               END-READ
           END-PERFORM

           CLOSE KUNDEFIL-IN
                 KUNDEFIL-OUT

           DISPLAY "Kundedata er nu skrevet til KundeoplysningerOut.txt"
           STOP RUN.

      *--------------------------------------------------------------
      *  HOVEDRUTINE: Behandling og skrivning af én kunde
      *--------------------------------------------------------------
       BEHANDL-KUNDE.
           PERFORM FORMAT-NAVN
           PERFORM FORMAT-KONTO
           PERFORM FORMAT-ADR
           PERFORM FORMAT-BY
           PERFORM FORMAT-KONTAKT

      *  SKRIV OUTPUT I RÆKKEFØLGE
           MOVE SPACES TO NAVN-ADR
           STRING "KUNDE-ID: " KUNDE-ID DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

           MOVE SPACES TO NAVN-ADR
           STRING "NAVN: " FULDT-NAVN DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

           MOVE SPACES TO NAVN-ADR
           STRING "KONTO: " KONTO-LINJE DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

           MOVE SPACES TO NAVN-ADR
           STRING "ADRESSE: " ADR-LINJE DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

           MOVE SPACES TO NAVN-ADR
           STRING "BY: " BY-LINJE DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

           MOVE SPACES TO NAVN-ADR
           STRING "KONTAKT: " KONTAKT-LINJE DELIMITED BY SIZE
                  INTO NAVN-ADR
           END-STRING
           WRITE KUNDE-ADR.

      *  BLANK LINJE MELLEM KUNDER
           MOVE SPACES TO NAVN-ADR
           WRITE KUNDE-ADR.
           EXIT.

      *--------------------------------------------------------------
      *  PARAGRAFFER TIL FORMATERING
      *--------------------------------------------------------------
       FORMAT-NAVN.
           MOVE SPACES TO FULDT-NAVN
           STRING FORNAVN DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  EFTERNAVN DELIMITED BY SPACE
                  INTO FULDT-NAVN
           END-STRING
           MOVE FUNCTION TRIM(FULDT-NAVN) TO FULDT-NAVN
           EXIT.

       FORMAT-KONTO.
           MOVE SPACES TO KONTO-LINJE
           STRING KONTONUMMER OF KONTOINFO DELIMITED BY SIZE
                  " - " DELIMITED BY SIZE
                  BALANCE OF KONTOINFO DELIMITED BY SIZE
                  " " DELIMITED BY SIZE
                  VALUTAKODE OF KONTOINFO DELIMITED BY SIZE
                  INTO KONTO-LINJE
           END-STRING
           EXIT.

       FORMAT-ADR.
           MOVE SPACES TO ADR-LINJE
           STRING VEJNAVN OF ADDRESSE DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  HUSNR OF ADDRESSE DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  ETAGE OF ADDRESSE DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  SIDE OF ADDRESSE DELIMITED BY SPACE
                  INTO ADR-LINJE
           END-STRING
           EXIT.

       FORMAT-BY.
           MOVE SPACES TO BY-LINJE
           STRING POSTNR OF ADDRESSE DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  BY-X OF ADDRESSE DELIMITED BY SPACE
                  INTO BY-LINJE
           END-STRING
           EXIT.

       FORMAT-KONTAKT.
           MOVE SPACES TO KONTAKT-LINJE
           STRING TELEFON OF KONTAKTINFO DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  EMAIL OF KONTAKTINFO DELIMITED BY SPACE
                  INTO KONTAKT-LINJE
           END-STRING
           EXIT.
