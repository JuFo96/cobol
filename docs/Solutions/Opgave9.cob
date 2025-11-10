       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave9.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT KUNDEFIL ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT KONTOFIL ASSIGN TO "KontoOpl.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-FIL ASSIGN TO "KUNDEKONTO.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  KUNDEFIL.
       01  KUNDE-REKORD.
           COPY "KUNDEOPL.cpy".

       FD  KONTOFIL.
       01  KONTO-REKORD.
           COPY "KONTOOPL.cpy".

       FD  OUT-FIL.
       01  OUT-REKORD.
           02 OUTPUT-TEXT        PIC X(150).

       WORKING-STORAGE SECTION.
       01  EOF-KUNDE            PIC X VALUE "N".
           88 END-KUNDE         VALUE "Y".
           88 MORE-KUNDE        VALUE "N".

       01  EOF-KONTI            PIC X VALUE "N".
           88 END-KONTI         VALUE "Y".
           88 MORE-KONTI        VALUE "N".

       01  FULDT-NAVN           PIC X(40) VALUE SPACES.
       01  ADR-LINJE1           PIC X(60) VALUE SPACES.
       01  ADR-LINJE2           PIC X(40) VALUE SPACES.

       *> Array til konti på 01 niveau
       01 KONTO-ARRAY OCCURS 50 TIMES.
           COPY "KONTOOPL.cpy".

       01 KONTO-COUNT           PIC 9(3) VALUE 0.
       01 IX-KONTI              PIC 9(3) VALUE 1.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           *> Læs kontofilen ind i array
           OPEN INPUT KONTOFIL
           MOVE 1 TO KONTO-COUNT
           MOVE "N" TO EOF-KONTI
           PERFORM UNTIL END-KONTI
               READ KONTOFIL
                   AT END
                       SET END-KONTI TO TRUE
                   NOT AT END
                       MOVE KONTO-REKORD TO KONTO-ARRAY(KONTO-COUNT)
                       ADD 1 TO KONTO-COUNT
               END-READ
           END-PERFORM
           CLOSE KONTOFIL

           OPEN INPUT KUNDEFIL
           OPEN OUTPUT OUT-FIL

           *> Læs kunder og match med konti i array
           PERFORM UNTIL END-KUNDE
               READ KUNDEFIL
                   AT END
                       SET END-KUNDE TO TRUE
                   NOT AT END
                       PERFORM FORMAT-NAVN
                       PERFORM FORMAT-VEJ
                       PERFORM FORMAT-BY
                       PERFORM SKRIV-KUNDE
                       PERFORM MATCH-KONTI
                       *> blank linje
                       MOVE SPACES TO OUTPUT-TEXT
                       WRITE OUT-REKORD
               END-READ
           END-PERFORM

           CLOSE KUNDEFIL
           CLOSE OUT-FIL
           STOP RUN.

       *> -------------------
       *> Formateringsparagraffer
       FORMAT-NAVN.
           STRING FORNAVN OF KUNDE-REKORD DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  EFTERNAVN OF KUNDE-REKORD DELIMITED BY SPACE
                  INTO FULDT-NAVN
           END-STRING
           EXIT.

       FORMAT-VEJ.
           STRING VEJNAVN OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                 " " HUSNR OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                 " " ETAGE OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                 " " SIDE OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                 INTO ADR-LINJE1
           END-STRING
           EXIT.

       FORMAT-BY.
           STRING POSTNR OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  " " BY-X OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  INTO ADR-LINJE2
           END-STRING
           EXIT.

       SKRIV-KUNDE.
           MOVE SPACES TO OUTPUT-TEXT
           STRING "Kunde-ID: " KUNDE-ID OF KUNDE-REKORD 
                   DELIMITED BY SIZE
                  " | Navn: " FULDT-NAVN DELIMITED BY SIZE
                  INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD

           MOVE SPACES TO OUTPUT-TEXT
           STRING "Adresse: " ADR-LINJE1 DELIMITED BY SIZE
                  ", " ADR-LINJE2 DELIMITED BY SIZE
                  INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD

           MOVE SPACES TO OUTPUT-TEXT
           STRING "Tlf: " TELEFON OF KONTAKTINFO OF KUNDE-REKORD 
                   DELIMITED BY SIZE
                  " | Email: " EMAIL OF KONTAKTINFO OF KUNDE-REKORD 
                   DELIMITED BY SIZE
                  INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           EXIT.

       MATCH-KONTI.
           PERFORM VARYING IX-KONTI FROM 1 BY 1 UNTIL IX-KONTI >= 
           KONTO-COUNT
               IF KUNDE-ID OF KONTO-ARRAY(IX-KONTI) = KUNDE-ID OF 
                  KUNDE-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "   Konto-ID: " KONTO-ID OF 
                          KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                          " | Type: " KONTO-TYPE OF 
                          KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                          " | Saldo: " BALANCE OF 
                          KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                          " " VALUTA-KD OF 
                           KONTO-ARRAY(IX-KONTI) DELIMITED BY SIZE
                          INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
               END-IF
           END-PERFORM
           EXIT.
