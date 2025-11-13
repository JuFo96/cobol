       identification division.
       program-id. ReadWriteFile.

       environment division.
       input-output section.
       file-control.
           select kunde-file assign to "kundeoplysninger.txt"
               organization is line sequential.

           select konto-file assign to "KontoOpl.txt"
               organization is line sequential.

           select output-file assign to "output.txt"
               organization is line sequential.
       data division.
           file section.
           FD kunde-file.
           01 kunde-info.
               COPY "kundeopl.cpy".
           
           FD konto-file.
           01 konto-info.
               COPY "KONTOOPL.cpy".  
 

           FD output-file.
            01 output-record.
               02 navn-adr         PIC X(100).
           

               
       working-storage section.
           01 end-of-file PIC X value "N".
           01 end-of-konto PIC X value "N".
           01 full-name PIC X(40).
           01 addresse PIC X(100).                                    
           01 konto-index PIC 9(2) value 0.
           01 current-index PIC 99 value 0.
           01 konto-array occurs 10 times.
               copy "KONTOOPL.cpy".  




       procedure division.

           open input konto-file
           
           perform until end-of-konto = "Y"
               read konto-file into konto-info
           at end 
               move "Y" to end-of-konto
           not at end 
           add 1 to konto-index
           move konto-info to konto-array(konto-index)
           end-read
           
           end-perform
           
           close konto-file
           open input kunde-file
           open output output-file
           
           
           
           
           perform until end-of-file = "Y"
               read kunde-file into kunde-info
               at end
                   move "Y" to end-of-file
               not at end
           perform handle-customer
           
           perform varying current-index
           from 0 by 1 
           until current-index > konto-index
           
           if customer-id in kunde-info = 
           customer-id in konto-array(current-index)
               perform format-konto
               perform format-balance
           end-if
           end-perform
           move "------------------------------------" to navn-adr
           write output-record
           end-read
           end-perform
           
           
  
           
           close kunde-file
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
                 function trim(customer-id in kunde-info)
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
       
           format-konto.
           move spaces to navn-adr
           string
               "Konto ID: " 
               function TRIM(account-id in konto-array(current-index))
               " Konto Type: " 
               function TRIM(account-type in konto-array(current-index))
               into navn-adr
           end-string
               write output-record
           exit.

           format-balance.
           move spaces to navn-adr
           string
               "Balance: " 
               function TRIM(balance in konto-array(current-index)) " "
               function TRIM(valuta-id in konto-array(current-index))
               into navn-adr
           end-string
               write output-record
           exit.
       