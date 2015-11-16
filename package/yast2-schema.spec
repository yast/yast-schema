#
# spec file for package yast2-schema
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           yast2-schema
Version:        3.1.0.2
Release:        0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

Group:	        System/YaST
License:        GPL-2.0+

# FIXME: drop yast2-all-packages some day
BuildRequires:	trang yast2-all-packages

# not covered by yast2-all-packages
BuildRequires:	yast2-online-update-configuration


# yast2-core omited from some reason in buildservice, adding explicitly
BuildRequires:  yast2-core

# openSUSE does not contain the registration module
%if %suse_version == 1315
BuildRequires:  yast2-registration
%endif

#!BuildIgnore: yast2-build-test yast2-online-update

# optimization suggested by AJ:
#!BuildIgnore: tomcat5

# ignoring conflicting packages
#!BuildIgnore: yast2-branding-SLED yast2-branding-openSUSE
#!BuildIgnore: yast2-theme yast2-theme-SLED yast2-theme-openSUSE yast2-theme-SLE

# Hotfix to build a package, bnc #427684
#!BuildIgnore: xerces-j2-bootstrap libusb-0_1-4 crimson

# Just a S390 thingie
#!BuildIgnore: yast2-reipl

# To speedup && to easily recover from dependency hell
#!BuildIgnore: yast2-pkg-bindings-devel-doc yast2-pkg-bindings zypper libzypp yast2-gtk yast2-qt yast2-ncurses yast2-qt-pkg yast2-ncurses-pkg

# Yast packages without AutoYast support
#!BuildIgnore: yast2-add-on-creator yast2-country-data yast2-firstboot yast2-live-installer yast2-product-creator yast2-trans-allpacks
#!BuildIgnore: yast2-control-center yast2-control-center-gnome yast2-control-center-qt

# Doc packages
# !BuildIgnore: yast2-devel-doc yast2-inetd-doc yast2-installation-devel-doc yast2-network-devel-doc yast2-nis-server-devel-doc yast2-printer-devel-doc

BuildArchitectures:	noarch

Summary:	YaST2 - AutoYaST Schema

%description
AutoYaST Syntax Schema

%prep
%setup -n %{name}-%{version}

%build
%yast_build

%install
%yast_install


%files
%defattr(-,root,root)
%dir %{yast_schemadir}/autoyast/rnc
%{yast_schemadir}/autoyast/rnc/profile.rnc
%{yast_schemadir}/autoyast/rnc/includes.rnc
%dir %{yast_schemadir}/autoyast/rng
%{yast_schemadir}/autoyast/rng/*.rng
%doc %{yast_docdir} 

