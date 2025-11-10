       identification division.
       program-id. HELLO.

       data division.
       working-storage section.
       01 VAR-TEXT PIC X(30) VALUE "Hello med variable".
       procedure division.
       display VAR-TEXT
       stop run.
       