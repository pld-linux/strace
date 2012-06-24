Summary:     	prints system call strace of a running process
Summary(de): 	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses. 
Summary(fr): 	affiche l'appel syst�me strace d'un processus en ex�cution.
Summary(pl): 	strace wy�wietla funkcje systemowe wywo�ywane przez uruchomiony proces
Summary(tr): 	�al��an bir s�recin yapt��� sistem �a�r�lar�n� listeler
Name:        	strace
Version:     	4.0
Release:     	1
Copyright:   	distributable
Group:       	Development/Debuggers
Group(pl):   	Programowanie/Odpluskwiacze
Source:      	http://www.wi.leidenuniv.nl/~wichert/strace/%{name}-%{version}.tar.gz
Patch:      	%{name}-fhs.patch
BuildRoot:	/tmp/%{name}-%{version}-root

%description
Strace prints a record of each system call another program makes, including
all of the arguments passed to it and the system call's return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm ausgegebenen
Systemaufrufe, einschlie�lich aller weitergeleiteten Argumente und dem
Ausgabewert des Systemaufrufs.

%description -l fr
strace affiche l'enregistrement de chaque appel syst�me que fait un programme
ainsi que tous les arguments qui lui ont �t� pass�s et la valeur de retour de
l'appel.

%description -l pl
Strace wy�wietla informacje o ka�dym wywo�aniu funkcji systemowych przez
uruchamiany program, w tym r�wnie� wszystkie argumenty wywo�ania i zwr�con�
warto��.

%description -l tr
strace bir program�n �al��t��� s�rece yapt��� b�t�n sistem �a�r�lar�n�,
g�nderdi�i parametreler ve geri d�n�� de�erleriyle birlikte d�ker.

%prep
%setup  -q 
%patch -p1 

%build
aclocal && autoconf && %configure
make LDFLAGS="-s"

%install
rm -rf $RPM_BUILD_ROOT

install -d $RPM_BUILD_ROOT%{_prefix}/{bin,share/man/man1}

make \
    prefix=$RPM_BUILD_ROOT%{_prefix} \
    mandir=$RPM_BUILD_ROOT%{_mandir} \
    bindir=$RPM_BUILD_ROOT%{_bindir} \
    install

gzip -9nf $RPM_BUILD_ROOT%{_mandir}/man1/* ChangeLog README-linux

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc {ChangeLog,README-linux}.gz

%attr(755,root,root) %{_bindir}/strace
%{_mandir}/man1/*

%changelog
* Sat Apr 24 1999 Tomasz K�oczko <kloczek@rudy.mif.pg.gda.pl>
  [3.1-18]
- added patches for arm arch and clone() (from rawhide),
- removed obsolete AC_C_CROSS macro from configure.in
  (strace-AC_C_CROSS.patch).

* Thu Apr 22 1999 Artur Frysiak <wiget@pld.org.pl>
  [3.1-14]
- removed man group from man pages
- compiled on rpm 3

* Wed Feb 17 1999 Micha� Kuratczyk <kura@wroclaw.art.pl>
  [3.1-13]
- added Group(pl)
- added gzipping man page

* Thu Oct 08 1998 Marcin Korzonek <mkorz@shadow.eu.org>
  [3.1-12]
- added translation pl.
- build against GNU libc-2.1
