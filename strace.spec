#
# Conditional build:
%bcond_without	libunwind	# strack tracing using libunwind
%bcond_without	libiberty	# symbol demangling in stack backtraces
#
%ifnarch %{ix86} %{x8664} x32 %{arm} hppa ia64 mips ppc ppc64 sh
%undefine	with_libunwind
%endif

%ifnarch aarch64
%define		with_mpers	1
%endif

Summary:	prints system call strace of a running process
Summary(de.UTF-8):	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses
Summary(es.UTF-8):	Enseña las llamadas de sistema de un proceso en ejecución
Summary(fr.UTF-8):	affiche l'appel système strace d'un processus en exécution
Summary(pl.UTF-8):	strace wyświetla funkcje systemowe wywoływane przez uruchomiony proces
Summary(pt_BR.UTF-8):	Mostra as chamadas de sistema de um processo rodando
Summary(ru.UTF-8):	Отслеживает и показывает системные вызовы, связанные с запущенным процессом
Summary(tr.UTF-8):	Çalışan bir sürecin yaptığı sistem çağrılarını listeler
Summary(uk.UTF-8):	Відслідковує та показує системні виклики, пов'язані із запущеним процесом
Name:		strace
Version:	6.13
Release:	1
License:	LGPL v2.1+
Group:		Development/Debuggers
Source0:	https://github.com/strace/strace/releases/download/v%{version}/%{name}-%{version}.tar.xz
# Source0-md5:	d6045bc205c1257a9f561670028cd63f
Source1:	%{name}.1.pl
URL:		https://strace.io/
# acl and libaio for headers only
BuildRequires:	acl-devel
%{?with_libiberty:BuildRequires:	binutils-devel >= 4:2.30-1}
BuildRequires:	libaio-devel
%{?with_libunwind:BuildRequires:	libunwind-devel}
BuildRequires:	tar >= 1:1.22
BuildRequires:	xz
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Strace prints a record of each system call another program makes,
including all of the arguments passed to it and the system call's
return value.

%description -l de.UTF-8
Strace druckt ein Protokoll aller von einem anderen Programm
ausgegebenen Systemaufrufe, einschließlich aller weitergeleiteten
Argumente und dem Ausgabewert des Systemaufrufs.

%description -l es.UTF-8
Strace imprime una "grabación" de cada llamada de sistema que el
programa hace, incluyendo todos los argumentos pasados para él, si la
vuelta de cada llamada de sistema es verdadera, o si hay creado error.

%description -l fr.UTF-8
strace affiche l'enregistrement de chaque appel système que fait un
programme ainsi que tous les arguments qui lui ont été passés et la
valeur de retour de l'appel.

%description -l pl.UTF-8
Strace wyświetla informacje o każdym wywołaniu funkcji systemowych
przez uruchamiany program, w tym również wszystkie argumenty wywołania
i zwróconą wartość.

%description -l pt_BR.UTF-8
Strace imprime uma "gravação" de cada chamada de sistema que o
programa faz, incluindo todos os argumentos passados para ele e se o
retorno de cada chamada de sistema é verdadeiro ou gerou erro.

%description -l ru.UTF-8
Программа strace перехватывает и регистрирует системные вызовы,
произведенные и полученные исполняющимся процессом. Strace может
вывести список всех системных вызовов, их аргументов и возвращаемые
ими значения. Strace полезна для диагностики проблем и отладки.

%description -l tr.UTF-8
strace bir programın çalıştığı sürece yaptığı bütün sistem
çağrılarını, gönderdiği parametreler ve geri dönüş değerleriyle
birlikte döker.

%description -l uk.UTF-8
Програма strace перехоплює та регіструє системні визови, зроблені та
отримані процесом, який виконується. Strace може вивести список усіх
системних визовів, їх аргументів та значень, які вони повернули.
Strace корисний для діагностики проблем та відладки.

%package graph
Summary:	strace graph
Summary(pl.UTF-8):	Graf strace
Group:		Development/Debuggers
# NOTE: doesn't require directly strace binary.

%description graph
strace-graph script processes strace -f output. It displays a graph of
invoked subprocesses, and is useful for finding out what complex
commands do.

The script can also handle the output with strace -t, -tt, or -ttt. It
will add elapsed time for each process in that case.

%description graph -l pl.UTF-8
Skrypt strace-graph przetwarza wynik strace -f i wyświetla graf
wywoływanych podprocesów. Jest przydatny do sprawdzania co robią
złożone polecenia.

Skrypt jest w stanie obsłużyć także wyjście ze strace -t, -tt i -ttt.
Doda wtedy upływający czas dla każdego procesu.

%prep
%setup -q

%build
%if %{with libunwind}
# workaround for:
# /usr/bin/ld: copy reloc against protected `_UPT_accessors' is invalid
# /usr/bin/ld: failed to set dynamic section sizes: Bad value
# (should be fixed in gcc >(=?) 5.1)
CFLAGS="%{rpmcflags} -fPIE"
%endif
%configure \
	%{!?with_libiberty:--without-libiberty} \
	%{!?with_libunwind:--without-libunwind} \
	--enable-mpers=%{?with_mpers:yes}%{!?with_mpers:no}
%{__make}

%install
rm -rf $RPM_BUILD_ROOT

%{__make} install \
	DESTDIR=$RPM_BUILD_ROOT

install -D %{SOURCE1} $RPM_BUILD_ROOT%{_mandir}/pl/man1/strace.1

cp -p src/strace-graph $RPM_BUILD_ROOT%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc COPYING CREDITS ChangeLog NEWS doc/README-linux-ptrace
%attr(755,root,root) %{_bindir}/strace
%attr(755,root,root) %{_bindir}/strace-log-merge
%{_mandir}/man1/strace.1*
%{_mandir}/man1/strace-log-merge.1*
%lang(pl) %{_mandir}/pl/man1/strace.1*

%files graph
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/strace-graph
