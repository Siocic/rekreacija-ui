# Flutter aplikacija za seminarski rad iz predmeta Razvoj Softvera 2

Aplikacija je razvijena kao dio seminarskog rada za predmet Razvoj Softvera 2. Na razvoju aplikacije radio sam u saradnji s kolegom [Ishak Isabegović](https://github.com/ishakisabegovic).  

Aplikacija je razvijena korištenjem tehnologija .NET i Flutter. Mobilna aplikacija podržava Android, dok desktop funkcioniše na Windows platformi.  
Aplikaciju je moguće pokrenuti i na iOS-u i Linuxu, ali ove platforme nisu bile prioritet tokom razvoja, što može rezultirati nepredviđenim greškama.  

## Opis
Aplikacija je namijenjena osobama koje se bave rekreacijom, s ciljem da lakše mogu rezervisati termine za dvorane i izvršiti online plaćanje.
Aplikacija je podijeljena u dva dijela, prema tipu korisnika:

---

👤 1. Fizička lica (rekreativci)
Korisnici koji se registruju kao fizička lica imaju pristup sljedećim funkcionalnostima putem mobilne aplikacije:

✅ Rezervacija termina za dvoranu
💳 Online plaćanje rezervisanog termina
⭐ Ostavljanje komentara i ocjena za dvorane
❤️ Dodavanje dvorana u omiljene
📅 Pregled prethodnih rezervacija
📰 Pregled novosti koje dvorane objavljuju
💬 Komunikacija sa vlasnicima dvorana putem poruka

---

🏢 2. Pravna lica (vlasnici dvorana)
Korisnici koji se registruju kao pravna lica čekaju odobrenje od superadmina. Nakon toga koriste desktop aplikaciju sa admin panelom, koji omogućava:

💰 Pregled zarade i mjesečnih rezervacija
⭐ Pregled recenzija korisnika
📊 Statistika najčešće rezervisanih objekata
➕ Dodavanje, uređivanje i brisanje vlastitih objekata
📢 Objavljivanje novosti/obavijesti za korisnike
✅ Upravljanje rezervacijama (prihvatanje ili odbijanje)
📬 Komunikacija sa korisnicima
📆 Upravljanje kalendarom – označavanje neradnih dana (praznici, odmori)

---

✅ Zaključak
Aplikacija pruža efikasan sistem za upravljanje rezervacijama sportskih objekata, olakšava komunikaciju između korisnika i vlasnika dvorana, i omogućava transparentno poslovanje za pravna lica.

## Instalacija i konfiguracija

### Prije same konfiguracije okruženja trebamo provjeriti da li imamo sve što nam je potrebno
- [Docker installed and running](https://www.docker.com/)
- [Rabbit MQ installed](https://www.rabbitmq.com/docs/install-windows#installer)
- Flutter
- An Android Emulator like Android Studio

### Prvo treba da namjestimo API okruženje, a to ćemo uraditi u sljedećim koracima.
- Klonirati projekat sa github repozitorija
- (https://github.com/Siocic/rekreacija-api)
- Otvorite glavni projekta
- Ubaciti .env file u folder
- Otvorite konzolu
- Upiste komandu `docker compose up`
- Sacekati da docker završi 

### Ako odaberemo rekreacija_desktop pratite sljedeće korake:
- Ako koristite windows omogućite Developer mode
- Otvorite IDE po vašem izboru
- Instalirajte potrebne dependencies:
- `flutter pub get`
- Pokrenite aplikaciju na Android Virtual Device iz Android Emulatora
- Pokrenite aplikaciju
- `flutter run -d windows`

### Ako odaberemo rekreacija_mobile pratite sljedeće korake:
- Otvorite IDE po vašem izboru
- Instalirajte potrebne dependencies:
- `flutter pub get`
- Pokrenite aplikaciju
- `flutter run`

## Kredencijali
Za desktop aplikaciju važe slijedeći kredencijali
### Superadmin
`email: superadmin.@email.com`
`password: 123Pa$$word`

### Pravno lice
`email: pravnolice.@email.com`
`password: 123Pa$$word`

### Za mobilnu aplikaciju su sljedeći kredencijali
### Fizičko lice
`email: fizickolice@email.com`
`password: 123Pa$$word`

## Paypal kredencijali
`email: rsrekreacija@email.com`
`password: 5L5r/0GL`