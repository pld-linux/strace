.\" {PTM/PB/0.1/18-05-1999/"¶led¼ wywo³ania systemowe i sygna³y"}
.\" Translation 1999 Przemek Borys <pborys@dione.ids.pl>
.\" Copyright (c) 1991, 1992 Paul Kranenburg <pk@cs.few.eur.nl>
.\" Copyright (c) 1993 Branko Lankester <branko@hacktic.nl>
.\" Copyright (c) 1993, 1994, 1995, 1996 Rick Sladkey <jrs@world.std.com>
.\" All rights reserved.
.\"
.\" Redistribution and use in source and binary forms, with or without
.\" modification, are permitted provided that the following conditions
.\" are met:
.\" 1. Redistributions of source code must retain the above copyright
.\"    notice, this list of conditions and the following disclaimer.
.\" 2. Redistributions in binary form must reproduce the above copyright
.\"    notice, this list of conditions and the following disclaimer in the
.\"    documentation and/or other materials provided with the distribution.
.\" 3. The name of the author may not be used to endorse or promote products
.\"    derived from this software without specific prior written permission.
.\"
.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
.\" IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
.\" OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
.\" IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
.\" INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
.\" NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
.\" DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
.\" THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
.\" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
.\" THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
.\"
.\"	$Id$
.\"
.de CW
.sp
.nf
.ft CW
..
.de CE
.ft
.fi
.sp
..
.TH STRACE 1 "96/02/13"
.SH NAZWA
strace \- ¶led¼ wywo³ania systemowe i sygna³y
.SH SK£ADNIA
.B strace
[
.B \-dffhiqrtttTvxx
]
[
.BI \-a kolumna
]
[
.BI \-e wyra¿
]
\&...
[
.BI \-o plik
]
[
.BI \-p pid
]
\&...
[
.BI \-s rozmiarnapisu
]
[
.BI \-u u¿ytkownik
]
[
.I komenda
[
.I arg
\&...
]
]
.sp
.B strace
.B \-c
[
.BI \-e wyra¿
]
\&...
[
.BI \-O wydatki
]
[
.BI \-S sortuj
]
[
.I komenda
[
.I arg
\&...
]
]
.SH OPIS
.IX "strace komenda" "" "\fLstrace\fR komenda"
.LP
W najprostszym przypadku, 
.B strace
wykonuje zadan± komendê 
.RI "`" komenda "'"
a¿ siê ona nie skoñczy.
Strace przechwytuje i nagrywa wywo³ania systemowe, dokonane przez proces,
oraz sygna³y, które do niego dotar³y. Nazwa ka¿dego wywo³ania, oraz jego
argumenty, s± wypisywane na wyj¶cie standardowe b³êdu, lub do pliku podanego
w opcji
.BR \-o . 
.LP
.B strace
jest u¿ytecznym narzêdziem diagnostyki, debuggowania. Administratorzy
systemów, diagnostycy i napotykacze problemów zauwa¿±, ¿e jest nieocenione
dla rozwi±zywania problemów z programami, których ¼róde³ nie ma wprost
dostêpnych. Strace bowiem nie potrzebuje rekompilacji aby go u¿yæ.
Studenci, hackerzy i ogólnie zainteresowani zauwa¿±, ¿e z ¶ledzenia wywo³añ
systemowych mo¿na siê wiele nauczyæ o systemie. Programi¶ci zauwa¿±, ¿e
skoro wywo³ania systemowe i sygna³y s± zdarzeniami zachodz±cymi na
interfejsie u¿ytkownik/j±dro, to ich bliska obserwacja mo¿e byæ bardzo
u¿yteczna do izolowania b³êdów, sprawdzania czysto¶ci i próbowania
wy³apywania ulotnych warunków.
.LP
Ka¿da ¶ledzona linia zawiera nazwê wywo³ania systemowego, za któr± nastêpuj±
jego argumenty, otoczone nawiasami, oraz jego warto¶æ zwracana.
Przyk³adowe ¶ledzenie komendy ``cat /dev/null'' daje:
.CW
open("/dev/null", O_RDONLY) = 3
.CE
Do b³êdów (zwykle warto¶ci zwracane \-1) dopisywany jest symbol errno i
napis b³êdu.
.CW
open("/foo/bar", O_RDONLY) = -1 ENOENT (No such file or directory)
.CE
Sygna³y s± drukowane jako symbol, oraz napis sygna³u. Fragment ¶ledzenia i
przerwania komendy ``sleep 666'' to:
.CW
sigsuspend([] <unfinished ...>
--- SIGINT (Interrupt) ---
+++ killed by SIGINT +++
.CE
Argumenty s± namiêtnie drukowane w formie symbolicznej.
Przyk³ad ten pokazuje dokonanie przekierowania ``>>xyzzy'':
.CW
open("xyzzy", O_WRONLY|O_APPEND|O_CREAT, 0666) = 3
.CE
Tutaj, wymienione trzy argumenty z open s± zdekodowane poprzez rozbicie
argumentu flagi na jego bitowe sk³adniki i wydrukowanie ich tradycyjnych
nazw, oraz warto¶ci ósemkowej praw. Choæ tradycyjne, lub natywne u¿ywanie
ró¿ni siê od ANSI lub POSIX, to te ostatnie formy s± jednak preferowane.
W niektórych wypadkach, wyj¶cie strace mo¿e byæ bardziej czytelne ni¿
¼ród³a.
.LP
Wska¼niki struktury s± dereferencjonowane, a cz³onkowie s± odpowiednio
wy¶wietlani. We wszystkich wypadkach argumenty s± formatowane w stylu C.
Na przyk³ad, istota komendy ``ls -l /dev/null'' jest przechwytywana jako:
.CW
lstat("/dev/null", {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
.CE
Zauwa¿, jak zdereferencjonowano argument `struct stat' i jak wy¶wietlono
ka¿dego cz³onka. Praktycznie, zauwa¿ jak ostro¿nie zosta³ zdekodowany
cz³onek st_mode na jego maskê bitow±. Zauwa¿ te¿, ¿e w tym przyk³adzie,
pierwszym argumentem lstat jest wej¶cie wywo³ania systemowego, a drugim jego
wyj¶cie. Poniewa¿ argumenty wyj¶ciowe nie s± modyfikowane je¶li wywo³anie
zawiedzie, argumenty nie zawsze mog± zostaæ zdereferencjonowane. Na przyk³ad
próba ``ls \-l'' na nieistniej±cym pliku da nastêpuj±c± liniê:
.CW
lstat("/foo/bar", 0xb004) = -1 ENOENT (No such file or directory)
.CE
.LP
Wska¼niki znakowe s± dereferencjonowane i wy¶wietlane jako napisy C.
Niedrukowalne znaki s± reprezentowane w kodach eskejpowych.
Drukowanych jest tylko pierwszych
.I rozmiarnapisu
(domy¶lnie 32) bajtów napisu;
d³u¿sze napisy maj± za zamykaj±cym cytatem do³±czone wielokropki.
Oto przyk³ad ``ls \-l'', gdzie funkcja biblioteki getpwuid odczytuje plik z
has³em:
.CW
read(3, "root::0:0:System Administrator:/"..., 1024) = 422
.CE
\fRPodczas gdy struktury s± notowane przy u¿yciu nawiasów klamrowych, zwyk³e
wska¼niki i tablice s± drukowane przy u¿yciu nawiasów kwadratowych, z
przecinkami oddzielaj±cymi elementy. Oto przyk³ad wywo³ania komendy ``id''
na systemie z dodatkowymi id grup:
.CW
getgroups(32, [100, 0]) = 2
.CE
\fRZ drugiej strony, zbiory bitowe te¿ s± pokazywane w nawiasach kwadratowych,
lecz elementy s± oddzielane tylko przez spacjê. Oto pow³oka, przygotowuj±ca
siê do wywo³ania komendy zewnêtrznej:
.CW
sigprocmask(SIG_BLOCK, [CHLD TTOU], []) = 0
.CE
\fRDrugi argument jest zbiorem bitowym dwóch sygna³ów, SIGCHLD i SIGTTOU.
W niektórych wypadkach, zbiory bitowe s± tak pe³ne, ¿e bardziej sensowne
jest drukowanie nieustawionych elementów. W takiej sytuacji zbiór jest
poprzedzony tyld±, jak w nastêpuj±cym przyk³adzie:
.CW
sigprocmask(SIG_UNBLOCK, ~[], NULL) = 0
.CE
\fRDrugi argument wskazuje, ¿e ustawiono ca³y zestaw sygna³ów.
.SH OPCJE
.TP 12
.TP
.B \-c
Zliczaj czas, wywo³ania i b³êdy dla ka¿dego wywo³ania systemowego i zg³o¶ na
koñcu raport.
.TP
.B \-d
Przeka¿ na
.I stderr 
wyj¶cie debuggowe strace.
.TP
.B \-f
¦led¼ procesy potomne, tworzone prze obecnie ¶ledzone procesy, jako rezultat
wywo³ania systemowego fork(2). Nowe procesy s± do³±czane tak szybko, jak
szybko zostaje uzyskany ich pid (poprzez warto¶æ zwracan± fork(2) w procesie
rodzicielskim). Oznacza to, ¿e takie dzieci mog± na chwilê byæ
niekontrolowane (szczególnie w wypadku vfork(2)), a¿ rodzic nie zostanie
znów wyshedulowany do dokoñczenia wywo³ania (v)fork(2).
Je¶li rodzic zdecyduje zaczekaæ (wait(2)) na dziecko, które obecnie jest
¶ledzone, zostaje on zawieszony a¿ potomek siê nie zakoñczy.
.TP
.B \-ff
opcja
.B \-o
.I nazwapliku
bêdzie dzia³aæ, ¶ledzenie ka¿dego procesu jest zapisywane do
.IR nazwapliku.pid ,
gdzie pid jest numerycznym identyfikatorem procesu.
.TP
.B \-F
Na SunOS 4.x opcja ta powoduje próbê pod±¿ania za vforkami poprzez triki
dynamicznego linkowania. W przeciwnym wypadku, vforki nie bêd± ¶ledzone,
nawet z podan± opcj±
.BR \-f .
.TP
.B \-h
Wydrukuj podsumowanie pomocy.
.TP
.B \-i
Drukuj podczas wywo³ania systemowego wska¼nik instrukcji.
.TP
.B \-q
Zahamuj komunikaty o przy³±czaniu, od³±czaniu, etc. Dzieje siê to
automatycznie gdy wyj¶cie jest przekierowywane do pliku, a komenda jest
wykonywana bezpo¶rednio, zamiast przy³±czania.
.TP
.B \-r
Drukuj wzglêdny timestamp podczas ka¿dego wywo³ania systemowego. Nagruwa to
ró¿nicê czasu miêdzy pocz±tkami kolejnych wywo³añ systemowych.
.TP
.B \-t
Poprzed¼ ka¿d± liniê trace czasem dnia.
.TP
.B \-tt
Je¶li podane dwukrotnie, wydrukowany czas w³±cza mikrosekundy.
.TP
.B \-ttt
Je¶li podane trzykrotnie, wydrukowany czas w³±cza mikrosekundy, a prowadz±ca
porcja bêdzie zawieraæ liczbê sekund od epoki.
.TP
.B \-T
Poka¿ czas spêdzony na wywo³aniach systemowych. Nagrywa to ró¿nice czasowe
miêdzy pocz±tkiem i koñcem ka¿dego wywo³ania systemowego.
.TP
.B \-v
Drukuj nieskrócone wersje wywo³añ environment, stat, termios, itp. 
Struktury te s± wspólne w wywo³aniach, wiêc domy¶lne zachowanie wy¶wietla
rozs±dny podzbiór cz³onków. Gdy uzyjesz tej opcji, wy¶wietlone zostanie
wszystko.
.TP
.B \-V
Wydrukuj numer wersji strace.
.TP
.B \-x
Drukuj wszystkie niedrukowalne napisy w formacie szesnastkowym.
.TP
.B \-xx
Drukuj wszystkie napisy w formacie szesnastkowym.
.TP
.BI "\-a " kolumna
Justuj zwracane warto¶ci w konkretnej kolumnie (domy¶lnie 40).
.TP
.BI "\-e " wyra¿
Wyra¿enie kwalifikuj±ce, okre¶laj±ce które zdarzenia ¶ledziæ, lub jak je
¶ledziæ. Formatem wyra¿enia jest:
.br
[kwalifikator=][!]warto¶æ1[,warto¶æ2]...
.br
gdzie kwalifikator jest jednym z trace, abbrev, verbose, raw, signal, read,
lub write, a warto¶æ jest zale¿naym od kwalifikatora symbolem, lub liczb±.
Domy¶lnym kwalifikatorem jest trace (¶led¼). U¿ycie wykrzyknika neguje zbiór
warto¶ci. Na przyk³ad \-eopen oznacza \-e trace=open, co z kolei oznacza, by
¶ledziæ tylko wywo³ania systemowe open. Odwrotnie, \-etrace=!open oznacza,
by ¶ledziæ wszystkie wywo³ania poza wywo³aniami open. Dodatkowo, istniej±
specjalne warto¶ci all (wszystko) i none (nic).
.LP
Zauwa¿, ¿e niektóre pow³oki u¿ywaj± wykrzyknika dla rozszerzenia histori;
nawet wewn±trz cytowanych argumentów. Je¶li tak bêdzie, musisz wyeskejpowaæ
wykrzyknik odwrotnym uko¶nikiem.
.TP
.BI "\-e trace=" zbiór
¦led¼ tylko podany zbiór wywo³añ systemowych. Opcja
.B \-c
jest u¿yteczna dla okre¶lania, które wywo³ania systemowe mog± byæ u¿yteczne
do ¶ledzenia. Na przyk³ad trace=open,close,read,write oznacza, by ¶ledziæ
tylko te cztery wywo³ania systemowe. Uwa¿aj z wyci±ganiem wniosków o ramce
u¿ytkownik/j±dro je¶li monitorujesz tylko podzbiór u¿ywanych wywo³añ
systemowych. Domy¶lnie, trace=all.
.TP
.B "\-e trace=file"
¦led¼ wszystkie wywo³ania systemowe, które bior± nazwê pliku jako argument.
Mo¿esz my¶leæ o tym jak o skrócie dla
.BR "\-e trace=open,stat,chmod,unlink," ...
co mo¿e byæ u¿yteczne dla sprawdzenia, które pliki s± wa¿ne dla procesu.
Co wiêcej, u¿ycie skrótu zapewni, ¿e przypadkiem nie zapomnisz do³±czyæ
wywo³ania w rodzaju
.BR lstat .
.TP
.B "\-e trace=process"
¦led¼ wszystkie wywo³ania systemowe, które zajmuj± siê zarz±dzaniem
procesami. Jest to przydatne do obserwowania kroków fork, wait i exec
procesu.
.TP
.B "\-e trace=network"
¦led¼ wszystkie wywo³ania zwi±zane z sieci±.
.TP
.B "\-e trace=signal"
¦led¼ wszystkie wywo³ania zwi±zane z sygna³ami.
.TP
.B "\-e trace=ipc"
¦led¼ wszystkie wywo³ania zwi±zane z IPC.
.TP
.BI "\-e abbrev=" zbiór
Skróæ wyj¶cie przez niedrukowanie ka¿dego cz³onka du¿ych struktur.
Domy¶lnie abbrev=all. Opcja
.B \-v
ma efekt abbrev=none.
.TP
.BI "\-e verbose=" zbiór
Dereferencjuj struktury podanego zestawu wywo³añ systemowych. Domy¶lnie jest
verbose=all.
.TP
.BI "\-e raw=" zbiór
Drukuj czyste, niezdekodowane argumenty podanych wywo³añ systemowych. Opcja
te powoduje, ¿e wszystkie argumenty s± drukowane szesnastkowo. Jest to
najbardziej u¿yteczne, je¶li nie ufasz dekodowaniu, lub je¶li potrzebujesz
znaæ w³a¶ciwe warto¶ci numeryczne argumentów.
.TP
.BI "\-e signal=" zbiór
¦led¼ tylko podany zbiór sygna³ów. Domy¶lnie jest signal=all. Na przyk³ad
signal=!SIGIO (lub signal=!io) powoduje, ¿e sygna³y SIGIO nie bêd± ¶ledzone.
.TP
.BI "\-e read=" zbiór
Dokonuj zrzutów szesnastkowych i ascii wszystkich danych odczytywanych z
deskryptorów podanych w zbiorze. Na przyk³ad, by zobaczyæ co dzieje siê na
wej¶ciu deskryptorów 3, 5, u¿yj:
.BR "\-e read=3,5" .
Zauwa¿, ¿e jest to niezale¿ne od normalnego ¶ledzenia wywo³ania read, które
jest kontrolowane opcj±
.BR "\-e trace=read" .
.TP
.BI "\-e write=" zbiór
Dokonuj zrzutów szesnastkowych i ascii wszystkich danych zapisywanych do
deskryptorów podanych w zbiorze. Na przyk³ad, by zobaczyæ co dzieje siê na
wyj¶ciu deskryptorów 3, 5, u¿yj:
.BR "\-e write=3,5" .
Zauwa¿, ¿e jest to niezale¿ne od normalnego ¶ledzenia wywo³ania write, które
jest kontrolowane opcj±
.BR "\-e trace=write" .
.TP
.BI "\-o " nazwapliku
Zapisuj wyj¶cie ¶ledzenia do pliku
.IR nazwapliku ,
a nie na standardowy b³±d.
U¿yj
.I nazwapliku.pid
je¶li u¿yto opcji
.BR \-ff .
Jesli argument zaczyna siê od `|' lub od `!', reszta argumentu traktowana
jest jak komenda i ca³e wyj¶cie jest do niej przesy³ane. Jest to przydatne
dla przekierowywania wyj¶cia debuggowego, nie dotykaj±c przekierowañ
normalnego wyj¶cia programu.
.TP
.BI "\-O " wydatki
Ustaw wydatki na ¶ledzenie wywo³añ systemowych na wydatki mikrosekund.
Jest to u¿yteczne dla przeci±¿enia domy¶lnej heurystyki dla zgadywania ile
czasu jest spêdzanego na czystym mierzeniu podczas timingowaniu wywo³añ
systemowych przy u¿yciu opcji
.BR \-c .
Dok³adno¶æ heurystyki mo¿e byæ ocenione przez timingowanie danego programu
bez ¶ledzenia i porównanie zebranego czasu wywo³añ systemowych do
ca³kowitego, wydanego przy u¿yciu
.B \-c .
.TP
.BI "\-p " pid
Podwie¶ siê do procesu o podanym identyfikatorze
.SM ID
.I pid
i rozpocznij ¶ledzenie.
¦ledzenie mo¿e byæ zakoñczone w dowolnym momencie przez przerwanie z
klawiatury (\c
.SM CTRL\s0-C).
.B strace
odpowie przez odwieszenie siê od ¶ledzonego procesu(ów), pozostawiaj±c go
(je) w spokoju.
Do podwieszenia siê do kolejnych 32 procesów, mo¿na u¿ywaæ wielu opcji
.BR \-p ,
jako uzupe³nienie komendy
.I komenda
(która jest opcjonalna, je¶li podano przynajmniej jedn± opcjê
.BR \-p ).
.TP
.BI "\-s " wielko¶ænapisu
Podaj maksymaln± d³ugo¶æ drukowanego napisu (domy¶lnie 32). Zauwa¿, ¿e
nazwy plików nie s± uwa¿ane za napisy i zawsze s± drukowane w ca³o¶ci.
.TP
.BI "\-S " sortuj
Sotruj wyj¶ciowy histogram opcji
.B \-c
wed³ug podanego kryterium. Legalnymi warto¶ciami s±
time, calls, name, i nothing (domy¶lne to time).
.TP
.BI "\-u " u¿ytkownik
Uruchom komendê z userid i groupid, oraz dodatkowymi grupami
.IR u¿ytkownika .
Opcja ta jest u¿yteczna tylko podczas pracy z roota i umo¿liwia w³a¶ciwe
wywo³anie binariów z ustawionymi sgid/suid.
Bez tej opcji, programy suid/sgid s± wywo³ywane bez efektywnych przywilejów.
.SH "INSTALACJA SETUID"
Je¶li
.B strace
jest zainstalowane z suid root, to u¿ytkownik wywo³uj±cy bêdzie móg³ siê
pod³±czyæ i ¶ledziæ procesy dowolnego innego u¿ytkownika.
Dodatkowo, programy suid i sgid bêd± wywo³ywane i ¶ledzonez w³a¶ciwymi
efektywnymi przywilejami. Poniewa¿ robiæ to powinni tylko zaufani
u¿ytkownicy z przywilejami roota, takie instalowanie
.B strace
ma sens tylko, je¶li u¿ytkownicy uprawnieni do jego wywo³ywania maj±
odpowiednie przywileje. Na przyk³ad sensowne jest instalowanie specjalnej
wersji
.B strace
z prawami `rwsr-xr--', dla u¿ytkownika root i grupy trace, gdzie cz³onkowie
grupy trace s± zaufanymi osobami. Je¶li u¿ywasz tej w³a¶ciwo¶ci, pamiêtej by
zainstalowaæ niesuidowan± wersjê strace dla zwyk³ych luserów.
.SH "ZOBACZ TAK¯E"
.BR ptrace(2) ,
.BR proc(4) ,
.BR time(1) ,
.BR trace(1) ,
.BR truss(1)
.SH UWAGI
Szkoda, ¿e w systemach z bibliotekami dzielonym jest produkowanych tyle
¶mieci podczas ¶ledzenia.
.LP
Jest dobrze my¶leæ o wej¶ciach i wyj¶ciach wywo³añ systemowych jak o
przep³ywie danych miêdzy przestrzeni± u¿ytkownika i j±dra. Poniewa¿
przestrzeñ u¿ytkownika i przestrzeñ j±dra s± oddzielone granic± ochrony
adresów, mo¿na czasem wyci±gaæ wnioski dedukcyjne o zachowaniu procesu na
podstawie warto¶ci wej¶cia i wyj¶cia.
.LP
W niektórych wypadkach wywo³anie systemowe mo¿e ró¿niæ siê od
udokumentowanego zachowania, lub mieæ inn± nazwê. Na przyk³ad na systemach
zgodnych z System V, rzeczywiste wywo³anie time(2) nie pobiera argumentu, a
funkcja stat nazywana jest xstat i bierze dodatkowy argument. 
Ró¿nice te s± normalne, lecz uczulone charakterystyki interfejsu wywo³añ
systemowych s± obs³ugiwane przez wrappery biblioteki C.
.LP
Na niektórych platformach proces, który ma za³±czone ¶ledzenie wywo³añ
systemowych z opcj±
.B \-p
otrzyma
.BR \s-1SIGSTOP\s0 .
Sygna³ ten mo¿e przerwaæ wywo³anie systemowe, które nie jest restartowalne.
Mo¿e to mieæ nieprzewidziane efekty na procesie, je¶li proces nie podejmuje
dzia³añ do restartowania wywo³ania systemowego.
.SH B£ÊDY
Programy, które u¿ywaj± bitu
.I setuid
nie bêd± mia³y efektywnych uprawnieñ u¿ytkownika podczas ¶ledzenia.
.LP
¦ledzony proces ignoruje
.SM SIGSTOP
(poza platformami SVR4).
.LP
¦ledzony proces, próbuj±cy zablokowaæ SIGTRAP otrzyma SIGSTOP w próbie
kontynuacji ¶ledzenia.
.LP
¦ledzony program dzia³a powoli.
.LP
¦ledzone procesy, które schodz± z komendy
.I komenda
mog± zostaæ pozostawione po sygnale przerwania (\c
.SM CTRL\s0-C).
.LP
Pod Linuksem, ¶ledzenie procesu init jest zabronione.
.LP
Opcja
.B \-i
jest s³abo wspierana.
.SH HISTORIA
.B strace
Oryginalny strace zosta³ napisany przez Paula Kranenburga
dla SunOS, który zosta³ zinspirowany narzêdziem trace.
Wersja SunOS strace zosta³a przeniesiona na Linuksa i rozszerzona przez
Branko Lankestera, który równie¿ napisa³ wsparcie j±dra Linuksa.
Mimo, ¿e Paul w 1992 wypu¶ci³ wersjê 2.5 strace, prace Branko opiera³y siê
na strace 1.5 z 1991. W 1993 Rick Sladkey po³±czy³ zmiany strace 2.5 z SunOS
ze zmianami wersji linuksowej, doda³ wiele w³a¶ciwo¶ci z truss'a z SVR4 i
wyda³ wersjê strace, która dzia³a³a na obydwu platformach. W 1994 Rick
przeportowa³ strace na SVR4 i Solaris, oraz napisa³ wsparcie automatycznej
konfiguracji. W 1995 przeportowa³ strace na Irixa i zmêczy³ siê pisaniem 
o sobie w trzeciej osobie.
.SH PROBLEMY
Problemy zwi±zane ze
.B strace
powinny byæ zg³aszane do obecnego opiekuna
.BR strace ,
którym jest Rick Sladkey <jrs@world.std.com>.
