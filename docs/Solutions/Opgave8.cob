       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave8.

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

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           OPEN INPUT KUNDEFIL
           OPEN OUTPUT OUT-FIL

           PERFORM UNTIL END-KUNDE
               READ KUNDEFIL
                   AT END
                       SET END-KUNDE TO TRUE
                   NOT AT END
                       *> Formater kundedata
                       PERFORM FORMAT-NAVN
                       PERFORM FORMAT-VEJ
                       PERFORM FORMAT-BY

                       *> Skriv kundeheader og adresse
                       PERFORM SKRIV-KUNDE

                       *> Læs og skriv konti for denne kunde
                       PERFORM LÆS-KONTI

                       *> Skriv en blank linje mellem kunder
                       MOVE SPACES TO OUTPUT-TEXT
                       WRITE OUT-REKORD
               END-READ
           END-PERFORM

           CLOSE KUNDEFIL
           CLOSE OUT-FIL
           STOP RUN.

       *> -------------------
       *> Paragraf til behandling af navn
       FORMAT-NAVN.
           STRING FORNAVN OF KUNDE-REKORD DELIMITED BY SPACE
                  " " DELIMITED BY SIZE
                  EFTERNAVN OF KUNDE-REKORD DELIMITED BY SPACE
                  INTO FULDT-NAVN
           END-STRING
           EXIT.
       *> Paragraf slut

       *> -------------------
       *> Paragraf til behandling af vejadresse
       FORMAT-VEJ.
           STRING VEJNAVN OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  " " HUSNR OF ADDRESSE OF KUNDE-REKORD 
                      DELIMITED BY SIZE
                  " " ETAGE OF ADDRESSE OF KUNDE-REKORD 
                      DELIMITED BY SIZE
                  " " SIDE OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  INTO ADR-LINJE1
           END-STRING
           EXIT.
       *> Paragraf slut

       *> -------------------
       *> Paragraf til behandling af by/postnummer
       FORMAT-BY.
           STRING POSTNR OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  " " BY-X OF ADDRESSE OF KUNDE-REKORD DELIMITED BY SIZE
                  INTO ADR-LINJE2
           END-STRING
           EXIT.
       *> Paragraf slut

       *> -------------------
       *> Paragraf til at skrive kundeinfo
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
       *> Paragraf slut

       *> -------------------
       *> Paragraf til læsning og skrivning af konti
       LÆS-KONTI.
           OPEN INPUT KONTOFIL
           MOVE "N" TO EOF-KONTI

           PERFORM UNTIL END-KONTI
               READ KONTOFIL
                   AT END
                       SET END-KONTI TO TRUE
                   NOT AT END
                       IF KUNDE-ID OF KONTO-REKORD = KUNDE-ID OF 
                                      KUNDE-REKORD
                           PERFORM SKRIV-KONTI
                       END-IF
               END-READ
           END-PERFORM

           CLOSE KONTOFIL
           EXIT.
       *> Paragraf slut

       *> -------------------
       *> Paragraf til skrivning af en enkelt konto
       SKRIV-KONTI.
           MOVE SPACES TO OUTPUT-TEXT
           STRING "   Konto-ID: " KONTO-ID OF KONTO-REKORD 
                                  DELIMITED BY SIZE
                  " | Type: "     KONTO-TYPE OF KONTO-REKORD 
                                  DELIMITED BY SIZE
                  " | Saldo: " BALANCE OF KONTO-REKORD 
                                  DELIMITED BY SIZE
                  " " VALUTA-KD OF KONTO-REKORD DELIMITED BY SIZE
                  INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           EXIT.
       *> Paragraf slut
