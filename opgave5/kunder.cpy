                   
           02 customer-id PIC X(10).
           02 first-name PIC X(20).
           02 last-name PIC X(20).
           02 account-info.
               03 account-number PIC X(20).
               03 balance PIC 9(7)V99.
               03 valutacode PIC X(3).
           02 adresse.
               03 street-name     PIC X(30).
               03 house-number    PIC X(5).
               03 etage           PIC X(5).
               03 side            PIC X(5).
               03 byn             PIC X(20).
               03 postnr          PIC X(4).
               03 lande-kode      PIC X(2).
           02.
               03 telefon         PIC X(8).
               03 email           PIC X(50).