Summary:     prints system call strace of a running process
Summary(de): druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses. 
Summary(fr): affiche l'appel système strace d'un processus en exécution.
Summary(pl): strace wy¶wietla funkcje systemowe wywo³ywane przez uruchomiony proces
Summary(tr): Çalýþan bir sürecin yaptýðý sistem çaðrýlarýný listeler
Name:        strace
Version:     3.1
Release:     13
Copyright:   distributable
Group:       Development/Debuggers
Group(pl):   Programowanie/Odpluskwiacze
Source:      ftp://ftp.std.com/pub/jrs/%{name}-%{version}.tar.gz
Patch0:      strace-3.0.14elf.patch
Patch1:      ftp://ftp.azstarnet.com/pub/linux/axp/glibc/strace-3.1-glibc.patch
Patch2:      strace-3.1-sparc.patch
Patch3:      strace-3.1-sparcglibc.patch
Patch4:      strace-3.1-sparc2.patch
Patch5:      strace-3.1-sparc3.patch
Patch6:      strace-3.1-sparc4.patch
Patch7:      strace-3.1-prctldomainname.patch
Patch8:      strace-3.1-alpha.patch
Patch9:      strace-3.1-gafton.patch
Patch10:     strace-3.1-sparc5.patch
Patch11:     strace-3.1-jbj.patch
Buildroot:   /tmp/%{name}-%{version}-root

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
%setup -q
%patch0 -p1 -b .elf
%patch1 -p1 -b .glibc
%patch2 -p1 -b .sparc
%patch3 -p1 -b .sparcglibc
%patch4 -p1 -b .sparc2
%patch5 -p1 -b .sparc3
%patch6 -p1 -b .sparc4
%patch7 -p1 -b .misc
%patch8 -p1 -b .alpha
%patch9 -p1 -b .gafton
%patch10 -p1 -b .sparc5
%patch11 -p1 -b .jbj


%build
autoconf
OS=`echo ${RPM_OS} | tr '[A-Z]' '[a-z]'`
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=/usr ${RPM_ARCH}-pld-${OS}
make

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/usr/{bin,man/man1}

make install prefix=$RPM_BUILD_ROOT/usr

strip $RPM_BUILD_ROOT/usr/bin/*

gzip -9nf $RPM_BUILD_ROOT/usr/man/man1/*

%clean
rm -rf $RPM_BUILD_ROOT

%files
%attr(755, root, root) /usr/bin/strace
%attr(644, root,  man) /usr/man/man1/*

%changelog
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
