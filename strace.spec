Summary:	prints system call strace of a running process
Summary(de):	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses
Summary(fr):	affiche l'appel système strace d'un processus en exécution
Summary(pl):	strace wy¶wietla funkcje systemowe wywo³ywane przez uruchomiony proces
Summary(tr):	Çalýþan bir sürecin yaptýðý sistem çaðrýlarýný listeler
Name:		strace
Version:	4.2
Release:	9
License:	distributable
Group:		Development/Debuggers
Group(pl):	Programowanie/Odpluskwiacze
Source0:	http://www.wi.leidenuniv.nl/~wichert/strace/%{name}-%{version}.tar.gz
Patch0:		%{name}-sparc.patch
Patch1:		%{name}-ia64.patch
Patch2:		%{name}-stat64.patch
Patch3:		%{name}-sparc2.patch
Patch4:		%{name}-putmsg.patch
Patch5:		%{name}-newsysc.patch
Patch6:		%{name}-do_not_check_for_libsnl.patch
Patch7:		%{name}-linux.patch
BuildRequires:	autoconf
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Strace prints a record of each system call another program makes,
including all of the arguments passed to it and the system call's
return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm
ausgegebenen Systemaufrufe, einschließlich aller weitergeleiteten
Argumente und dem Ausgabewert des Systemaufrufs.

%description -l fr
strace affiche l'enregistrement de chaque appel système que fait un
programme ainsi que tous les arguments qui lui ont été passés et la
valeur de retour de l'appel.

%description -l pl
Strace wy¶wietla informacje o ka¿dym wywo³aniu funkcji systemowych
przez uruchamiany program, w tym równie¿ wszystkie argumenty wywo³ania
i zwrócon± warto¶æ.

%description -l tr
strace bir programýn çalýþtýðý sürece yaptýðý bütün sistem
çaðrýlarýný, gönderdiði parametreler ve geri dönüþ deðerleriyle
birlikte döker.

%prep
%setup  -q 
%patch0 -p1 
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1
%patch6 -p1
%patch7 -p1

%build
autoconf
autoheader
%configure
%{__make} LDFLAGS="-s"

%install
rm -rf $RPM_BUILD_ROOT

install -d $RPM_BUILD_ROOT{%{_bindir},%{_mandir}/man1}

%{__make} install \
	prefix=$RPM_BUILD_ROOT%{_prefix} \
	mandir=$RPM_BUILD_ROOT%{_mandir} \
	bindir=$RPM_BUILD_ROOT%{_bindir}

gzip -9nf $RPM_BUILD_ROOT%{_mandir}/man1/* ChangeLog README-linux

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc {ChangeLog,README-linux}.gz

%attr(755,root,root) %{_bindir}/strace
%{_mandir}/man1/*
