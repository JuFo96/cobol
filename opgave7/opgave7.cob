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
           01 addresse PIC X(100).


       procedure division.
               open input input-file
               open output output-file

               perform until end-of-file = "Y"
                   read input-file into input-record
               at end
                   move "Y" to end-of-file
               not at end
               perform handle-customer
               move "--------------------------------------" to navn-adr
               write output-record
           
               end-read
               end-perform
               close input-file
               close output-file
               stop run.
           
           handle-customer.
             perform format-id
             perform format-navn
             perform format-addresse
             perform format-by
             perform format-kontakt
           exit.
         

           format-id.
               move spaces to navn-adr
               string             
                   "ID: " 
                   function trim(customer-id)
                   into navn-adr
               end-string
                   write output-record
           exit.

           format-navn.
               move spaces to navn-adr
               STRING 
                   "Navn: "
                   function trim(first-name) " "                        
                   function trim(last-name) 
                   into navn-adr
               end-string
                   write output-record
           exit.




           format-addresse.
           move spaces to navn-adr
           string 
               "Addresse: "
               function TRIM(street-name) " "
               function TRIM(house-number) ", "
               function TRIM(etage) "."
               function TRIM(side)  
               into navn-adr
           end-string
               write output-record
           exit.
            
           format-by.
           move spaces to navn-adr
           display postnr
           string 
              "By: "
              function TRIM(postnr) " "
              function TRIM(bynavn) " "
              into navn-adr
           end-string
               write output-record  
           exit.            
           
           format-kontakt.
           move spaces to navn-adr
           string 
              "Kontakt: " "tlf:" 
              function TRIM(telefon) " email:"
              function TRIM(email)
              into navn-adr
           end-string
               write output-record
           exit.
       
       