Summary:	prints system call strace of a running process
Summary(de):	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses
Summary(es):	EnseЯa las llamadas de sistema de un proceso en ejecuciСn
Summary(fr):	affiche l'appel systХme strace d'un processus en exИcution
Summary(pl):	strace wy╤wietla funkcje systemowe wywoЁywane przez uruchomiony proces
Summary(pt_BR):	Mostra as chamadas de sistema de um processo rodando
Summary(ru):	Отслеживает и показывает системные вызовы, связанные с запущенным процессом
Summary(tr):	гalЩЧan bir sЭrecin yaptЩПЩ sistem ГaПrЩlarЩnЩ listeler
Summary(uk):	В╕дсл╕дкову╓ та показу╓ системн╕ виклики, пов'язан╕ ╕з запущеним процесом
Name:		strace
Version:	4.5.4
Release:	1
License:	BSD-like
Group:		Development/Debuggers
Source0:	http://dl.sourceforge.net/strace/%{name}-%{version}.tar.bz2
# Source0-md5:	c61bb4f1c86f9929442b4868995b5b6f
Source1:	%{name}.1.pl
Patch0:		%{name}-newsysc.patch
Patch1:		%{name}-getdents64.patch
Patch2:		%{name}-kernel26_userspace.patch
Patch3:		%{name}-stat64.patch
URL:		http://www.liacs.nl/~wichert/strace/
BuildRequires:	autoconf >= 2.54
BuildRequires:	automake
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Strace prints a record of each system call another program makes,
including all of the arguments passed to it and the system call's
return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm
ausgegebenen Systemaufrufe, einschlieъlich aller weitergeleiteten
Argumente und dem Ausgabewert des Systemaufrufs.

%description -l es
Strace imprime una "grabaciСn" de cada llamada de sistema que el
programa hace, incluyendo todos los argumentos pasados para Иl, si la
vuelta de cada llamada de sistema es verdadera, o si hay creado error.

%description -l fr
strace affiche l'enregistrement de chaque appel systХme que fait un
programme ainsi que tous les arguments qui lui ont ИtИ passИs et la
valeur de retour de l'appel.

%description -l pl
Strace wy╤wietla informacje o ka©dym wywoЁaniu funkcji systemowych
przez uruchamiany program, w tym rСwnie© wszystkie argumenty wywoЁania
i zwrСcon╠ warto╤Ф.

%description -l pt_BR
Strace imprime uma "gravaГЦo" de cada chamada de sistema que o
programa faz, incluindo todos os argumentos passados para ele e se o
retorno de cada chamada de sistema И verdadeiro ou gerou erro.

%description -l ru
Программа strace перехватывает и регистрирует системные вызовы,
произведенные и полученные исполняющимся процессом. Strace может
вывести список всех системных вызовов, их аргументов и возвращаемые
ими значения. Strace полезна для диагностики проблем и отладки.

%description -l tr
strace bir programЩn ГalЩЧtЩПЩ sЭrece yaptЩПЩ bЭtЭn sistem
ГaПrЩlarЩnЩ, gЖnderdiПi parametreler ve geri dЖnЭЧ deПerleriyle
birlikte dЖker.

%description -l uk
Програма strace перехоплю╓ та рег╕стру╓ системн╕ визови, зроблен╕ та
отриман╕ процесом, який викону╓ться. Strace може вивести список ус╕х
системних визов╕в, ╖х аргумент╕в та значень, як╕ вони повернули.
Strace корисний для д╕агностики проблем та в╕дладки.

%prep
%setup -q
%patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1

%build
%{__aclocal}
%{__autoconf}
%{__autoheader}
%{__automake}
%configure
%{__make}

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{_mandir}/{man1,pl/man1}}

%{__make} install \
	prefix=$RPM_BUILD_ROOT%{_prefix} \
	mandir=$RPM_BUILD_ROOT%{_mandir} \
	bindir=$RPM_BUILD_ROOT%{_bindir}

install %{SOURCE1} $RPM_BUILD_ROOT%{_mandir}/pl/man1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc COPYRIGHT CREDITS ChangeLog NEWS README-linux TODO
%attr(755,root,root) %{_bindir}/strace*
%{_mandir}/man1/*
%lang(pl) %{_mandir}/pl/man1/*
