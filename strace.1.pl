.\" {PTM/PB/0.1/18-05-1999/"�led� wywo�ania systemowe i sygna�y"}
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
strace \- �led� wywo�ania systemowe i sygna�y
.SH SK�ADNIA
.B strace
[
.B \-dffhiqrtttTvxx
]
[
.BI \-a kolumna
]
[
.BI \-e wyra�
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
.BI \-u u�ytkownik
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
.BI \-e wyra�
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
wykonuje zadan� komend� 
.RI "`" komenda "'"
a� si� ona nie sko�czy.
Strace przechwytuje i nagrywa wywo�ania systemowe, dokonane przez proces,
oraz sygna�y, kt�re do niego dotar�y. Nazwa ka�dego wywo�ania, oraz jego
argumenty, s� wypisywane na wyj�cie standardowe b��du, lub do pliku podanego
w opcji
.BR \-o . 
.LP
.B strace
jest u�ytecznym narz�dziem diagnostyki, debuggowania. Administratorzy
system�w, diagnostycy i napotykacze problem�w zauwa��, �e jest nieocenione
dla rozwi�zywania problem�w z programami, kt�rych �r�de� nie ma wprost
dost�pnych. Strace bowiem nie potrzebuje rekompilacji aby go u�y�.
Studenci, hackerzy i og�lnie zainteresowani zauwa��, �e z �ledzenia wywo�a�
systemowych mo�na si� wiele nauczy� o systemie. Programi�ci zauwa��, �e
skoro wywo�ania systemowe i sygna�y s� zdarzeniami zachodz�cymi na
interfejsie u�ytkownik/j�dro, to ich bliska obserwacja mo�e by� bardzo
u�yteczna do izolowania b��d�w, sprawdzania czysto�ci i pr�bowania
wy�apywania ulotnych warunk�w.
.LP
Ka�da �ledzona linia zawiera nazw� wywo�ania systemowego, za kt�r� nast�puj�
jego argumenty, otoczone nawiasami, oraz jego warto�� zwracana.
Przyk�adowe �ledzenie komendy ``cat /dev/null'' daje:
.CW
open("/dev/null", O_RDONLY) = 3
.CE
Do b��d�w (zwykle warto�ci zwracane \-1) dopisywany jest symbol errno i
napis b��du.
.CW
open("/foo/bar", O_RDONLY) = -1 ENOENT (No such file or directory)
.CE
Sygna�y s� drukowane jako symbol, oraz napis sygna�u. Fragment �ledzenia i
przerwania komendy ``sleep 666'' to:
.CW
sigsuspend([] <unfinished ...>
--- SIGINT (Interrupt) ---
+++ killed by SIGINT +++
.CE
Argumenty s� nami�tnie drukowane w formie symbolicznej.
Przyk�ad ten pokazuje dokonanie przekierowania ``>>xyzzy'':
.CW
open("xyzzy", O_WRONLY|O_APPEND|O_CREAT, 0666) = 3
.CE
Tutaj, wymienione trzy argumenty z open s� zdekodowane poprzez rozbicie
argumentu flagi na jego bitowe sk�adniki i wydrukowanie ich tradycyjnych
nazw, oraz warto�ci �semkowej praw. Cho� tradycyjne, lub natywne u�ywanie
r�ni si� od ANSI lub POSIX, to te ostatnie formy s� jednak preferowane.
W niekt�rych wypadkach, wyj�cie strace mo�e by� bardziej czytelne ni�
�r�d�a.
.LP
Wska�niki struktury s� dereferencjonowane, a cz�onkowie s� odpowiednio
wy�wietlani. We wszystkich wypadkach argumenty s� formatowane w stylu C.
Na przyk�ad, istota komendy ``ls -l /dev/null'' jest przechwytywana jako:
.CW
lstat("/dev/null", {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
.CE
Zauwa�, jak zdereferencjonowano argument `struct stat' i jak wy�wietlono
ka�dego cz�onka. Praktycznie, zauwa� jak ostro�nie zosta� zdekodowany
cz�onek st_mode na jego mask� bitow�. Zauwa� te�, �e w tym przyk�adzie,
pierwszym argumentem lstat jest wej�cie wywo�ania systemowego, a drugim jego
wyj�cie. Poniewa� argumenty wyj�ciowe nie s� modyfikowane je�li wywo�anie
zawiedzie, argumenty nie zawsze mog� zosta� zdereferencjonowane. Na przyk�ad
pr�ba ``ls \-l'' na nieistniej�cym pliku da nast�puj�c� lini�:
.CW
lstat("/foo/bar", 0xb004) = -1 ENOENT (No such file or directory)
.CE
.LP
Wska�niki znakowe s� dereferencjonowane i wy�wietlane jako napisy C.
Niedrukowalne znaki s� reprezentowane w kodach eskejpowych.
Drukowanych jest tylko pierwszych
.I rozmiarnapisu
(domy�lnie 32) bajt�w napisu;
d�u�sze napisy maj� za zamykaj�cym cytatem do��czone wielokropki.
Oto przyk�ad ``ls \-l'', gdzie funkcja biblioteki getpwuid odczytuje plik z
has�em:
.CW
read(3, "root::0:0:System Administrator:/"..., 1024) = 422
.CE
\fRPodczas gdy struktury s� notowane przy u�yciu nawias�w klamrowych, zwyk�e
wska�niki i tablice s� drukowane przy u�yciu nawias�w kwadratowych, z
przecinkami oddzielaj�cymi elementy. Oto przyk�ad wywo�ania komendy ``id''
na systemie z dodatkowymi id grup:
.CW
getgroups(32, [100, 0]) = 2
.CE
\fRZ drugiej strony, zbiory bitowe te� s� pokazywane w nawiasach kwadratowych,
lecz elementy s� oddzielane tylko przez spacj�. Oto pow�oka, przygotowuj�ca
si� do wywo�ania komendy zewn�trznej:
.CW
sigprocmask(SIG_BLOCK, [CHLD TTOU], []) = 0
.CE
\fRDrugi argument jest zbiorem bitowym dw�ch sygna��w, SIGCHLD i SIGTTOU.
W niekt�rych wypadkach, zbiory bitowe s� tak pe�ne, �e bardziej sensowne
jest drukowanie nieustawionych element�w. W takiej sytuacji zbi�r jest
poprzedzony tyld�, jak w nast�puj�cym przyk�adzie:
.CW
sigprocmask(SIG_UNBLOCK, ~[], NULL) = 0
.CE
\fRDrugi argument wskazuje, �e ustawiono ca�y zestaw sygna��w.
.SH OPCJE
.TP 12
.TP
.B \-c
Zliczaj czas, wywo�ania i b��dy dla ka�dego wywo�ania systemowego i zg�o� na
ko�cu raport.
.TP
.B \-d
Przeka� na
.I stderr 
wyj�cie debuggowe strace.
.TP
.B \-f
�led� procesy potomne, tworzone prze obecnie �ledzone procesy, jako rezultat
wywo�ania systemowego fork(2). Nowe procesy s� do��czane tak szybko, jak
szybko zostaje uzyskany ich pid (poprzez warto�� zwracan� fork(2) w procesie
rodzicielskim). Oznacza to, �e takie dzieci mog� na chwil� by�
niekontrolowane (szczeg�lnie w wypadku vfork(2)), a� rodzic nie zostanie
zn�w wyshedulowany do doko�czenia wywo�ania (v)fork(2).
Je�li rodzic zdecyduje zaczeka� (wait(2)) na dziecko, kt�re obecnie jest
�ledzone, zostaje on zawieszony a� potomek si� nie zako�czy.
.TP
.B \-ff
opcja
.B \-o
.I nazwapliku
b�dzie dzia�a�, �ledzenie ka�dego procesu jest zapisywane do
.IR nazwapliku.pid ,
gdzie pid jest numerycznym identyfikatorem procesu.
.TP
.B \-F
Na SunOS 4.x opcja ta powoduje pr�b� pod��ania za vforkami poprzez triki
dynamicznego linkowania. W przeciwnym wypadku, vforki nie b�d� �ledzone,
nawet z podan� opcj�
.BR \-f .
.TP
.B \-h
Wydrukuj podsumowanie pomocy.
.TP
.B \-i
Drukuj podczas wywo�ania systemowego wska�nik instrukcji.
.TP
.B \-q
Zahamuj komunikaty o przy��czaniu, od��czaniu, etc. Dzieje si� to
automatycznie gdy wyj�cie jest przekierowywane do pliku, a komenda jest
wykonywana bezpo�rednio, zamiast przy��czania.
.TP
.B \-r
Drukuj wzgl�dny timestamp podczas ka�dego wywo�ania systemowego. Nagruwa to
r�nic� czasu mi�dzy pocz�tkami kolejnych wywo�a� systemowych.
.TP
.B \-t
Poprzed� ka�d� lini� trace czasem dnia.
.TP
.B \-tt
Je�li podane dwukrotnie, wydrukowany czas w��cza mikrosekundy.
.TP
.B \-ttt
Je�li podane trzykrotnie, wydrukowany czas w��cza mikrosekundy, a prowadz�ca
porcja b�dzie zawiera� liczb� sekund od epoki.
.TP
.B \-T
Poka� czas sp�dzony na wywo�aniach systemowych. Nagrywa to r�nice czasowe
mi�dzy pocz�tkiem i ko�cem ka�dego wywo�ania systemowego.
.TP
.B \-v
Drukuj nieskr�cone wersje wywo�a� environment, stat, termios, itp. 
Struktury te s� wsp�lne w wywo�aniach, wi�c domy�lne zachowanie wy�wietla
rozs�dny podzbi�r cz�onk�w. Gdy uzyjesz tej opcji, wy�wietlone zostanie
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
Justuj zwracane warto�ci w konkretnej kolumnie (domy�lnie 40).
.TP
.BI "\-e " wyra�
Wyra�enie kwalifikuj�ce, okre�laj�ce kt�re zdarzenia �ledzi�, lub jak je
�ledzi�. Formatem wyra�enia jest:
.br
[kwalifikator=][!]warto��1[,warto��2]...
.br
gdzie kwalifikator jest jednym z trace, abbrev, verbose, raw, signal, read,
lub write, a warto�� jest zale�naym od kwalifikatora symbolem, lub liczb�.
Domy�lnym kwalifikatorem jest trace (�led�). U�ycie wykrzyknika neguje zbi�r
warto�ci. Na przyk�ad \-eopen oznacza \-e trace=open, co z kolei oznacza, by
�ledzi� tylko wywo�ania systemowe open. Odwrotnie, \-etrace=!open oznacza,
by �ledzi� wszystkie wywo�ania poza wywo�aniami open. Dodatkowo, istniej�
specjalne warto�ci all (wszystko) i none (nic).
.LP
Zauwa�, �e niekt�re pow�oki u�ywaj� wykrzyknika dla rozszerzenia histori;
nawet wewn�trz cytowanych argument�w. Je�li tak b�dzie, musisz wyeskejpowa�
wykrzyknik odwrotnym uko�nikiem.
.TP
.BI "\-e trace=" zbi�r
�led� tylko podany zbi�r wywo�a� systemowych. Opcja
.B \-c
jest u�yteczna dla okre�lania, kt�re wywo�ania systemowe mog� by� u�yteczne
do �ledzenia. Na przyk�ad trace=open,close,read,write oznacza, by �ledzi�
tylko te cztery wywo�ania systemowe. Uwa�aj z wyci�ganiem wniosk�w o ramce
u�ytkownik/j�dro je�li monitorujesz tylko podzbi�r u�ywanych wywo�a�
systemowych. Domy�lnie, trace=all.
.TP
.B "\-e trace=file"
�led� wszystkie wywo�ania systemowe, kt�re bior� nazw� pliku jako argument.
Mo�esz my�le� o tym jak o skr�cie dla
.BR "\-e trace=open,stat,chmod,unlink," ...
co mo�e by� u�yteczne dla sprawdzenia, kt�re pliki s� wa�ne dla procesu.
Co wi�cej, u�ycie skr�tu zapewni, �e przypadkiem nie zapomnisz do��czy�
wywo�ania w rodzaju
.BR lstat .
.TP
.B "\-e trace=process"
�led� wszystkie wywo�ania systemowe, kt�re zajmuj� si� zarz�dzaniem
procesami. Jest to przydatne do obserwowania krok�w fork, wait i exec
procesu.
.TP
.B "\-e trace=network"
�led� wszystkie wywo�ania zwi�zane z sieci�.
.TP
.B "\-e trace=signal"
�led� wszystkie wywo�ania zwi�zane z sygna�ami.
.TP
.B "\-e trace=ipc"
�led� wszystkie wywo�ania zwi�zane z IPC.
.TP
.BI "\-e abbrev=" zbi�r
Skr�� wyj�cie przez niedrukowanie ka�dego cz�onka du�ych struktur.
Domy�lnie abbrev=all. Opcja
.B \-v
ma efekt abbrev=none.
.TP
.BI "\-e verbose=" zbi�r
Dereferencjuj struktury podanego zestawu wywo�a� systemowych. Domy�lnie jest
verbose=all.
.TP
.BI "\-e raw=" zbi�r
Drukuj czyste, niezdekodowane argumenty podanych wywo�a� systemowych. Opcja
te powoduje, �e wszystkie argumenty s� drukowane szesnastkowo. Jest to
najbardziej u�yteczne, je�li nie ufasz dekodowaniu, lub je�li potrzebujesz
zna� w�a�ciwe warto�ci numeryczne argument�w.
.TP
.BI "\-e signal=" zbi�r
�led� tylko podany zbi�r sygna��w. Domy�lnie jest signal=all. Na przyk�ad
signal=!SIGIO (lub signal=!io) powoduje, �e sygna�y SIGIO nie b�d� �ledzone.
.TP
.BI "\-e read=" zbi�r
Dokonuj zrzut�w szesnastkowych i ascii wszystkich danych odczytywanych z
deskryptor�w podanych w zbiorze. Na przyk�ad, by zobaczy� co dzieje si� na
wej�ciu deskryptor�w 3, 5, u�yj:
.BR "\-e read=3,5" .
Zauwa�, �e jest to niezale�ne od normalnego �ledzenia wywo�ania read, kt�re
jest kontrolowane opcj�
.BR "\-e trace=read" .
.TP
.BI "\-e write=" zbi�r
Dokonuj zrzut�w szesnastkowych i ascii wszystkich danych zapisywanych do
deskryptor�w podanych w zbiorze. Na przyk�ad, by zobaczy� co dzieje si� na
wyj�ciu deskryptor�w 3, 5, u�yj:
.BR "\-e write=3,5" .
Zauwa�, �e jest to niezale�ne od normalnego �ledzenia wywo�ania write, kt�re
jest kontrolowane opcj�
.BR "\-e trace=write" .
.TP
.BI "\-o " nazwapliku
Zapisuj wyj�cie �ledzenia do pliku
.IR nazwapliku ,
a nie na standardowy b��d.
U�yj
.I nazwapliku.pid
je�li u�yto opcji
.BR \-ff .
Jesli argument zaczyna si� od `|' lub od `!', reszta argumentu traktowana
jest jak komenda i ca�e wyj�cie jest do niej przesy�ane. Jest to przydatne
dla przekierowywania wyj�cia debuggowego, nie dotykaj�c przekierowa�
normalnego wyj�cia programu.
.TP
.BI "\-O " wydatki
Ustaw wydatki na �ledzenie wywo�a� systemowych na wydatki mikrosekund.
Jest to u�yteczne dla przeci��enia domy�lnej heurystyki dla zgadywania ile
czasu jest sp�dzanego na czystym mierzeniu podczas timingowaniu wywo�a�
systemowych przy u�yciu opcji
.BR \-c .
Dok�adno�� heurystyki mo�e by� ocenione przez timingowanie danego programu
bez �ledzenia i por�wnanie zebranego czasu wywo�a� systemowych do
ca�kowitego, wydanego przy u�yciu
.B \-c .
.TP
.BI "\-p " pid
Podwie� si� do procesu o podanym identyfikatorze
.SM ID
.I pid
i rozpocznij �ledzenie.
�ledzenie mo�e by� zako�czone w dowolnym momencie przez przerwanie z
klawiatury (\c
.SM CTRL\s0-C).
.B strace
odpowie przez odwieszenie si� od �ledzonego procesu(�w), pozostawiaj�c go
(je) w spokoju.
Do podwieszenia si� do kolejnych 32 proces�w, mo�na u�ywa� wielu opcji
.BR \-p ,
jako uzupe�nienie komendy
.I komenda
(kt�ra jest opcjonalna, je�li podano przynajmniej jedn� opcj�
.BR \-p ).
.TP
.BI "\-s " wielko��napisu
Podaj maksymaln� d�ugo�� drukowanego napisu (domy�lnie 32). Zauwa�, �e
nazwy plik�w nie s� uwa�ane za napisy i zawsze s� drukowane w ca�o�ci.
.TP
.BI "\-S " sortuj
Sotruj wyj�ciowy histogram opcji
.B \-c
wed�ug podanego kryterium. Legalnymi warto�ciami s�
time, calls, name, i nothing (domy�lne to time).
.TP
.BI "\-u " u�ytkownik
Uruchom komend� z userid i groupid, oraz dodatkowymi grupami
.IR u�ytkownika .
Opcja ta jest u�yteczna tylko podczas pracy z roota i umo�liwia w�a�ciwe
wywo�anie binari�w z ustawionymi sgid/suid.
Bez tej opcji, programy suid/sgid s� wywo�ywane bez efektywnych przywilej�w.
.SH "INSTALACJA SETUID"
Je�li
.B strace
jest zainstalowane z suid root, to u�ytkownik wywo�uj�cy b�dzie m�g� si�
pod��czy� i �ledzi� procesy dowolnego innego u�ytkownika.
Dodatkowo, programy suid i sgid b�d� wywo�ywane i �ledzonez w�a�ciwymi
efektywnymi przywilejami. Poniewa� robi� to powinni tylko zaufani
u�ytkownicy z przywilejami roota, takie instalowanie
.B strace
ma sens tylko, je�li u�ytkownicy uprawnieni do jego wywo�ywania maj�
odpowiednie przywileje. Na przyk�ad sensowne jest instalowanie specjalnej
wersji
.B strace
z prawami `rwsr-xr--', dla u�ytkownika root i grupy trace, gdzie cz�onkowie
grupy trace s� zaufanymi osobami. Je�li u�ywasz tej w�a�ciwo�ci, pami�tej by
zainstalowa� niesuidowan� wersj� strace dla zwyk�ych luser�w.
.SH "ZOBACZ TAK�E"
.BR ptrace(2) ,
.BR proc(4) ,
.BR time(1) ,
.BR trace(1) ,
.BR truss(1)
.SH UWAGI
Szkoda, �e w systemach z bibliotekami dzielonym jest produkowanych tyle
�mieci podczas �ledzenia.
.LP
Jest dobrze my�le� o wej�ciach i wyj�ciach wywo�a� systemowych jak o
przep�ywie danych mi�dzy przestrzeni� u�ytkownika i j�dra. Poniewa�
przestrze� u�ytkownika i przestrze� j�dra s� oddzielone granic� ochrony
adres�w, mo�na czasem wyci�ga� wnioski dedukcyjne o zachowaniu procesu na
podstawie warto�ci wej�cia i wyj�cia.
.LP
W niekt�rych wypadkach wywo�anie systemowe mo�e r�ni� si� od
udokumentowanego zachowania, lub mie� inn� nazw�. Na przyk�ad na systemach
zgodnych z System V, rzeczywiste wywo�anie time(2) nie pobiera argumentu, a
funkcja stat nazywana jest xstat i bierze dodatkowy argument. 
R�nice te s� normalne, lecz uczulone charakterystyki interfejsu wywo�a�
systemowych s� obs�ugiwane przez wrappery biblioteki C.
.LP
Na niekt�rych platformach proces, kt�ry ma za��czone �ledzenie wywo�a�
systemowych z opcj�
.B \-p
otrzyma
.BR \s-1SIGSTOP\s0 .
Sygna� ten mo�e przerwa� wywo�anie systemowe, kt�re nie jest restartowalne.
Mo�e to mie� nieprzewidziane efekty na procesie, je�li proces nie podejmuje
dzia�a� do restartowania wywo�ania systemowego.
.SH B��DY
Programy, kt�re u�ywaj� bitu
.I setuid
nie b�d� mia�y efektywnych uprawnie� u�ytkownika podczas �ledzenia.
.LP
�ledzony proces ignoruje
.SM SIGSTOP
(poza platformami SVR4).
.LP
�ledzony proces, pr�buj�cy zablokowa� SIGTRAP otrzyma SIGSTOP w pr�bie
kontynuacji �ledzenia.
.LP
�ledzony program dzia�a powoli.
.LP
�ledzone procesy, kt�re schodz� z komendy
.I komenda
mog� zosta� pozostawione po sygnale przerwania (\c
.SM CTRL\s0-C).
.LP
Pod Linuksem, �ledzenie procesu init jest zabronione.
.LP
Opcja
.B \-i
jest s�abo wspierana.
.SH HISTORIA
.B strace
Oryginalny strace zosta� napisany przez Paula Kranenburga
dla SunOS, kt�ry zosta� zinspirowany narz�dziem trace.
Wersja SunOS strace zosta�a przeniesiona na Linuksa i rozszerzona przez
Branko Lankestera, kt�ry r�wnie� napisa� wsparcie j�dra Linuksa.
Mimo, �e Paul w 1992 wypu�ci� wersj� 2.5 strace, prace Branko opiera�y si�
na strace 1.5 z 1991. W 1993 Rick Sladkey po��czy� zmiany strace 2.5 z SunOS
ze zmianami wersji linuksowej, doda� wiele w�a�ciwo�ci z truss'a z SVR4 i
wyda� wersj� strace, kt�ra dzia�a�a na obydwu platformach. W 1994 Rick
przeportowa� strace na SVR4 i Solaris, oraz napisa� wsparcie automatycznej
konfiguracji. W 1995 przeportowa� strace na Irixa i zm�czy� si� pisaniem 
o sobie w trzeciej osobie.
.SH PROBLEMY
Problemy zwi�zane ze
.B strace
powinny by� zg�aszane do obecnego opiekuna
.BR strace ,
kt�rym jest Rick Sladkey <jrs@world.std.com>.
