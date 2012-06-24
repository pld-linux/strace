Summary:	prints system call strace of a running process
Summary(de):	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses
Summary(fr):	affiche l'appel syst�me strace d'un processus en ex�cution
Summary(pl):	strace wy�wietla funkcje systemowe wywo�ywane przez uruchomiony proces
Summary(tr):	�al��an bir s�recin yapt��� sistem �a�r�lar�n� listeler
Name:		strace
Version:	4.3
Release:	1
License:	Distributable
Group:		Development/Debuggers
Group(de):	Entwicklung/Debugger
Group(pl):	Programowanie/Odpluskwiacze
Source0:	http://download.sourceforge.net/strace/%{name}-%{version}.tar.bz2
Patch0:		%{name}-sparc.patch
Patch1:		%{name}-sparc2.patch
Patch2:		%{name}-sparc3.patch
Patch3:		%{name}-putmsg.patch
Patch4:		%{name}-newsysc.patch
Patch5:		%{name}-getdents64.patch
URL:		http://www.liacs.nl/~wichert/strace/
BuildRequires:	autoconf
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Strace prints a record of each system call another program makes,
including all of the arguments passed to it and the system call's
return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm
ausgegebenen Systemaufrufe, einschlie�lich aller weitergeleiteten
Argumente und dem Ausgabewert des Systemaufrufs.

%description -l fr
strace affiche l'enregistrement de chaque appel syst�me que fait un
programme ainsi que tous les arguments qui lui ont �t� pass�s et la
valeur de retour de l'appel.

%description -l pl
Strace wy�wietla informacje o ka�dym wywo�aniu funkcji systemowych
przez uruchamiany program, w tym r�wnie� wszystkie argumenty wywo�ania
i zwr�con� warto��.

%description -l tr
strace bir program�n �al��t��� s�rece yapt��� b�t�n sistem
�a�r�lar�n�, g�nderdi�i parametreler ve geri d�n�� de�erleriyle
birlikte d�ker.

%prep
%setup  -q 
%patch0 -p1 
%patch1 -p1
# Temporary not used (problems on sparc/2.2?)
#%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1

%build
autoconf
autoheader
# for 2.4 you can and even should remove these two kernel_Xid32_t definitions
CFLAGS="%{rpmcflags} -D__kernel_uid32_t=uid_t -D__kernel_gid32_t=gid_t"
export CFLAGS
%configure
%{__make} 

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{_mandir}/man1}

%{__make} install \
	prefix=$RPM_BUILD_ROOT%{_prefix} \
	mandir=$RPM_BUILD_ROOT%{_mandir} \
	bindir=$RPM_BUILD_ROOT%{_bindir}

gzip -9nf ChangeLog README-linux

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc *.gz
%attr(755,root,root) %{_bindir}/strace
%{_mandir}/man1/*
