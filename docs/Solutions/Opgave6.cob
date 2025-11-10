       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave6.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT KUNDEFIL ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  KUNDEFIL.
       01 KUNDE-REKORD.
           COPY "KUNDEOPL.cpy".

       WORKING-STORAGE SECTION.
       01 EOF-FLAG           PIC X VALUE "N".
           88 END-OF-FILE   VALUE "Y".
           88 MORE-TO-READ  VALUE "N".

       01 FULDT-NAVN         PIC X(40) VALUE SPACES.
       01 RENS-FULDT-NAVN    PIC X(40) VALUE SPACES.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           OPEN INPUT KUNDEFIL

           PERFORM UNTIL END-OF-FILE
               READ KUNDEFIL
                   AT END
                       SET END-OF-FILE TO TRUE
                   NOT AT END
                       *> Sammensæt fuldt navn
                       STRING FORNAVN DELIMITED BY SIZE
                              " " DELIMITED BY SIZE
                              EFTERNAVN DELIMITED BY SIZE
                         INTO FULDT-NAVN
                       END-STRING
                       MOVE FUNCTION TRIM(FULDT-NAVN) TO RENS-FULDT-NAVN

                       DISPLAY "---------------- Kunde ---------------"
                       DISPLAY "Kunde ID       : " KUNDE-ID
                       DISPLAY "Navn (renset)  : " RENS-FULDT-NAVN
                       DISPLAY "Kontonummer    : " KONTONUMMER OF 
                       KONTOINFO
                       DISPLAY "Balance        : " BALANCE OF KONTOINFO 
                       " " VALUTAKODE OF KONTOINFO
                       DISPLAY "Adresse        : " VEJNAVN OF ADDRESSE 
                       " " HUSNR OF ADDRESSE ", "
                                                     ETAGE OF ADDRESSE 
                                                     SIDE OF ADDRESSE
                       DISPLAY "By/Postnr      : " BY-X OF ADDRESSE " "
                        POSTNR OF ADDRESSE
                       DISPLAY "Telefon/Email  : " TELEFON OF 
                       KONTAKTINFO " " EMAIL OF KONTAKTINFO
               END-READ
           END-PERFORM

           CLOSE KUNDEFIL
           STOP RUN.
