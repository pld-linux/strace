Summary:     	prints system call strace of a running process
Summary(de): 	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses. 
Summary(fr): 	affiche l'appel système strace d'un processus en exécution.
Summary(pl): 	strace wy¶wietla funkcje systemowe wywo³ywane przez uruchomiony proces
Summary(tr): 	Çalýþan bir sürecin yaptýðý sistem çaðrýlarýný listeler
Name:        	strace
Version:     	3.1
Release:     	18
Copyright:   	distributable
Group:       	Development/Debuggers
Group(pl):   	Programowanie/Odpluskwiacze
Source:      	ftp://ftp.std.com/pub/jrs/%{name}-%{version}.tar.gz
Patch0:      	strace-elf.patch.gz
Patch1:      	ftp://ftp.azstarnet.com/pub/linux/axp/glibc/strace-3.1-glibc.patch
Patch2:      	strace-sparc.patch.gz
Patch3:      	strace-sparcglibc.patch
Patch4:      	strace-sparc2.patch
Patch5:      	strace-sparc3.patch
Patch6:      	strace-sparc4.patch
Patch7:      	strace-domainname.patch
Patch8:      	strace-alpha.patch
Patch9:      	strace-gafton.patch.gz
Patch10:     	strace-sparc5.patch
Patch11:     	strace-jbj.patch
Patch12:	strace-glibc-2.1.patch
Patch13:	strace-prctl.patch
Patch14:	strace-fork.patch
Patch15:	strace-arm.patch
Patch16:	strace-clone.patch
Patch17:	strace-AC_C_CROSS.patch
Buildroot:   	/tmp/%{name}-%{version}-root

%description
Strace prints a record of each system call another program makes, including
all of the arguments passed to it and the system call's return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm ausgegebenen
Systemaufrufe, einschließlich aller weitergeleiteten Argumente und dem
Ausgabewert des Systemaufrufs.

%description -l fr
strace affiche l'enregistrement de chaque appel système que fait un programme
ainsi que tous les arguments qui lui ont été passés et la valeur de retour de
l'appel.

%description -l pl
Strace wy¶wietla informacje o ka¿dym wywo³aniu funkcji systemowych przez
uruchamiany program, w tym równie¿ wszystkie argumenty wywo³ania i zwrócon±
warto¶æ.

%description -l tr
strace bir programýn çalýþtýðý sürece yaptýðý bütün sistem çaðrýlarýný,
gönderdiði parametreler ve geri dönüþ deðerleriyle birlikte döker.

%prep
%setup   -q
%patch0  -p1 
%patch1  -p1 
%patch2  -p1
%patch3  -p1 
%patch4  -p1 
%patch5  -p1 
%patch6  -p1
%patch7  -p1
%patch8  -p1
%patch9  -p1 
%patch10 -p1
%patch11 -p1
%patch12 -p1
%patch13 -p1
%patch14 -p1
%patch15 -p1
%patch16 -p0
%patch17 -p1

%build
autoconf
%configure
make LDFLAGS="-s"

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/usr/{bin,man/man1}

make install prefix=$RPM_BUILD_ROOT/usr

gzip -9nf $RPM_BUILD_ROOT%{_mandir}/man1/*

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/strace
%{_mandir}/man1/*

%changelog
* Sat Apr 24 1999 Tomasz K³oczko <kloczek@rudy.mif.pg.gda.pl>
  [3.1-18]
- added patches for arm arch and clone() (from rawhide),
- removed obsolete AC_C_CROSS macro from configure.in
  (strace-AC_C_CROSS.patch).

* Thu Apr 22 1999 Artur Frysiak <wiget@pld.org.pl>
  [3.1-14]
- removed man group from man pages
- compiled on rpm 3

* Wed Feb 17 1999 Micha³ Kuratczyk <kura@wroclaw.art.pl>
  [3.1-13]
- added Group(pl)
- added gzipping man page

* Thu Oct 08 1998 Marcin Korzonek <mkorz@shadow.eu.org>
  [3.1-12]
- added translation pl.

* Wed Sep 30 1998 Jeff Johnson <jbj@redhat.com>
- fix typo (printf, not tprintf).

* Sat Sep 19 1998 Jeff Johnson <jbj@redhat.com>
- fix compile problem on sparc.

* Tue Aug 18 1998 Cristian Gafton <gafton@redhat.com>
- buildroot

* Mon Jul 20 1998 Cristian Gafton <gafton@redhat.com>
- added the umoven patch from James Youngman <jay@gnu.org>
- fixed build problems on newer glibc releases

* Mon Jun 08 1998 Prospector System <bugs@redhat.com>
- translations modified for de, fr, tr
