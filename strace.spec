# TODO
# - rel 2 & STBR after translation of -graph subpackage
Summary:	prints system call strace of a running process
Summary(de):	druckt ein Protokoll der Systemaufrufe eines laufenden Prozesses
Summary(es):	Ense�a las llamadas de sistema de un proceso en ejecuci�n
Summary(fr):	affiche l'appel syst�me strace d'un processus en ex�cution
Summary(pl):	strace wy�wietla funkcje systemowe wywo�ywane przez uruchomiony proces
Summary(pt_BR):	Mostra as chamadas de sistema de um processo rodando
Summary(ru):	����������� � ���������� ��������� ������, ��������� � ���������� ���������
Summary(tr):	�al��an bir s�recin yapt��� sistem �a�r�lar�n� listeler
Summary(uk):	����̦����դ �� �����դ ������Φ �������, ���'���Φ �� ��������� ��������
Name:		strace
Version:	4.5.12
Release:	1.1
License:	BSD-like
Group:		Development/Debuggers
Source0:	http://dl.sourceforge.net/strace/%{name}-%{version}.tar.bz2
# Source0-md5:	c9dc77b9bd7f144f317e8289e0f6d40b
Source1:	%{name}.1.pl
Patch0:		%{name}-newsysc.patch
Patch1:		%{name}-getdents64.patch
Patch2:		%{name}-kernel26_userspace.patch
Patch3:		%{name}-stat64.patch
Patch4:		%{name}-sparc64.patch
URL:		http://www.liacs.nl/~wichert/strace/
BuildRequires:	autoconf >= 2.57
BuildRequires:	automake
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Strace prints a record of each system call another program makes,
including all of the arguments passed to it and the system call's
return value.

%description -l de
Strace druckt ein Protokoll aller von einem anderen Programm
ausgegebenen Systemaufrufe, einschlie�lich aller weitergeleiteten
Argumente und dem Ausgabewert des Systemaufrufs.

%description -l es
Strace imprime una "grabaci�n" de cada llamada de sistema que el
programa hace, incluyendo todos los argumentos pasados para �l, si la
vuelta de cada llamada de sistema es verdadera, o si hay creado error.

%description -l fr
strace affiche l'enregistrement de chaque appel syst�me que fait un
programme ainsi que tous les arguments qui lui ont �t� pass�s et la
valeur de retour de l'appel.

%description -l pl
Strace wy�wietla informacje o ka�dym wywo�aniu funkcji systemowych
przez uruchamiany program, w tym r�wnie� wszystkie argumenty wywo�ania
i zwr�con� warto��.

%description -l pt_BR
Strace imprime uma "grava��o" de cada chamada de sistema que o
programa faz, incluindo todos os argumentos passados para ele e se o
retorno de cada chamada de sistema � verdadeiro ou gerou erro.

%description -l ru
��������� strace ������������� � ������������ ��������� ������,
������������� � ���������� ������������� ���������. Strace �����
������� ������ ���� ��������� �������, �� ���������� � ������������
��� ��������. Strace ������� ��� ����������� ������� � �������.

%description -l tr
strace bir program�n �al��t��� s�rece yapt��� b�t�n sistem
�a�r�lar�n�, g�nderdi�i parametreler ve geri d�n�� de�erleriyle
birlikte d�ker.

%description -l uk
�������� strace ���������� �� ��Ǧ���դ ������Φ ������, ������Φ ��
������Φ ��������, ���� �����դ����. Strace ���� ������� ������ �Ӧ�
��������� ����צ�, �� �������Ԧ� �� �������, �˦ ���� ���������.
Strace �������� ��� Ħ��������� ������� �� צ������.

%package graph
Summary:	strace graph
Group:		Development/Debuggers
# NOTE: doesn't require directly strace binary.

%description graph
strace-graph script processes strace -f output. It displays a graph of
invoked subprocesses, and is useful for finding out what complex
commands do.

The script can also handle the output with strace -t, -tt, or -ttt.
It will add elapsed time for each process in that case.

%prep
%setup -q
%patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1

%build
%{__aclocal}
%{__autoconf}
%{__autoheader}
%{__automake}
%configure
%{__make}

%install
rm -rf $RPM_BUILD_ROOT

%{__make} install \
	DESTDIR=$RPM_BUILD_ROOT

install -D %{SOURCE1} $RPM_BUILD_ROOT%{_mandir}/pl/man1/strace.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc COPYRIGHT CREDITS ChangeLog NEWS README-linux TODO
%attr(755,root,root) %{_bindir}/strace
%{_mandir}/man1/*
%lang(pl) %{_mandir}/pl/man1/*

%files graph
%attr(755,root,root) %{_bindir}/strace-graph
