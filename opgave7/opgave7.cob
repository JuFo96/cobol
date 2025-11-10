       identification division.
       program-id. ReadWriteFile.

       environment division.
       input-output section.
       file-control.
           select input-file assign to "kundeoplysninger.txt"
               organization is line sequential.
           select output-file assign to "output.txt"
               organization is line sequential.
       data division.
           file section.
           FD input-file.
           01 input-record.
               05 customer-id PIC X(10).
               05 first-name PIC X(20).
               05 last-name PIC X(20).

               05 adresse.
                      07 street-name     PIC X(30).
                      07 house-number    PIC X(5).
                      07 etage           PIC X(5).
                      07 side            PIC X(5).
                      07 bynavn          PIC X(20).
                      07 postnr          PIC X(4).
                      07 lande-kode      PIC X(2).
                 05 personal-info.
                     07 telefon         PIC X(8).
                     07 email           PIC X(50).


           FD output-file.
            01 output-record.
               02 navn-adr         PIC X(100).
           
               
       working-storage section.
           01 end-of-file PIC X value "N".
           01 full-name PIC X(40).
           01 addresse PIC X.

           01 ws-street PIC X(30).
           01 ws-house PIC X(5).
           01 ws-etage PIC X(5).
           01 ws-side PIC X(5).


       procedure division.
       main-procedure.
               open input input-file
               open output output-file

               perform until end-of-file = "Y"
                   read input-file into input-record
               at end
                   move "Y" to end-of-file
               not at end
      * ID to field             
                   move customer-id to navn-adr
                   write output-record
      * Name to field
                   STRING 
                       first-name                        
                           delimited by space
                       " "
                           delimited by size 
                       last-name 
                           delimited by size
                       into full-name
                   move full-name to navn-adr
                   write output-record
      * addres to field

           MOVE FUNCTION TRIM(street-name) TO ws-street
           MOVE FUNCTION TRIM(house-number) TO ws-house
           MOVE FUNCTION TRIM(etage) TO ws-etage
           MOVE FUNCTION TRIM(side) TO ws-side

           STRING 
               ws-street DELIMITED BY space
               " " DELIMITED BY space
               ws-house DELIMITED BY space
               " " DELIMITED BY space
               ws-etage DELIMITED BY space
               " " DELIMITED BY space
               ws-side DELIMITED BY space
               INTO addresse
           END-STRING
               move addresse to navn-adr
                   write output-record
                   
                   
                   display "kunde id: " ws-house ws-street
                   end-read
               end-perform
               close input-file
               close output-file
       stop run.
       