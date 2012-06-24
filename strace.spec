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
