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

           FD output-file.
            01 output-record.
               05 customer-id PIC X(10).
               05 first-name PIC X(20).
               05 last-name PIC X(20).
               
       working-storage section.
           01 end-of-file PIC X value "N".
           01 temp-id PIC X(10).

       procedure division.
       main-procedure.
               open input input-file
               open output output-file

               perform until end-of-file = "Y"
                   read input-file into input-record
                       at end
                           move "Y" to end-of-file
                       not at end
                   move input-record to output-record
                   write output-record
                   display "kunde id: " customer-id in output-record
                   end-read
               end-perform
               close input-file
               close output-file
       stop run.
       