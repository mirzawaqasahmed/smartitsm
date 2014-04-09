#!/bin/bash


## smartITSM Demo System
## Copyright (C) 2012 synetics GmbH <http://www.smartitsm.org/>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.


## CPAN


MODULE="cpan"
TITLE="CPAN"
DESCRIPTION="Perl and CPAN"
VERSIONS="Perl 5.14.2, CPAN"
PRIORITY="20"


## Installs this module.
function do_install {
    loginfo "Preparing CPAN..."
    perl -e 'for ( @INC ) { print -e $_ ? "Exists:  " : "Missing: ", $_, "\n" }' || return 1
    mkdir -p /usr/local/lib/perl/5.14.2 /usr/local/share/perl/5.14.2 /usr/local/lib/site_perl || return 1
    {
        echo "o conf build_requires_install_policy yes"
        echo "o conf prerequisites_policy follow"
        echo "o conf commit"
        echo "exit"
    } | cpan || return 1

    # TODO "Somewhere" is a prompt for "Press <enter> to see the detailed list." and "Do you want to proceed with this configuration? [yes]" -- just enter:
    installCPANmodule "CPAN" || return 1
    installCPANmodule "YAML" || return 1
    installCPANmodule "YAML::XS" || return 1
    installCPANmodule "Test::Output" || return 1
    installCPANmodule "Test::Pod" || return 1
    installCPANmodule "Test::Pod::Coverage" || return 1
    installCPANmodule "Test::CPAN::Meta::JSON" || return 1
    installCPANmodule "Module::Install::AuthorTests" || return 1
    installCPANmodule "Module::Install::ExtraTests" || return 1
    installCPANmodule "GD::Text" || return 1
    installCPANmodule "Moose" || return 1
    installCPANmodule "XML::Entities" || return 1
    installCPANmodule "XML::Simple" || return 1
    installCPANmodule "Compress::Zlib" || return 1
    installCPANmodule "DBI" || return 1
    installCPANmodule "Apache::DBI" || return 1
    installCPANmodule "Net::IP" || return 1
    installCPANmodule "SOAP::Lite" || return 1
    installCPANmodule "Encode::HanExtra" || return 1
    # TODO no extended tests needed, type 'n' and ENTER:
    installCPANmodule "Mail::IMAPClient" || return 1
    installCPANmodule "Net::DNS" || return 1
    installCPANmodule "Net::SMTP::TLS::ButMaintained" || return 1
    installCPANmodule "PDF::API2" || return 1
    installCPANmodule "Text::CSV_XS" || return 1
    installCPANmodule "LWP::UserAgent" || return 1
    installCPANmodule "Digest::MD5" || return 1
    # TODO skip external tests (network connectivity required), type ENTER:
    installCPANmodule "Net::SSLeay" || return 1
    installCPANmodule "Proc::Daemon" || return 1
    installCPANmodule "Proc::PID::File" || return 1
    # TODO say "y" to all questions (5 times), type ENTER:
    installCPANmodule "Nmap::Parser" || return 1
    installCPANmodule "JSON::XS" || return 1
    installCPANmodule "Module::Install" || return 1
    # TODO no live tests, type 'N' and ENTER
    installCPANmodule "Crypt::SSLeay" || return 1
    installCPANmodule "GD::Graph" || return 1
    installCPANmodule "Net::LDAP" || return 1
    installCPANmodule "Crypt::Eksblowfish::Bcrypt" || return 1

    return 0
}

## Installs homepage configuration.
function do_www_install {
    loginfo "Installing homepage configuration..."
    logdebug "Nothing to do. Skipping."
    return 0
}

## Upgrades this module.
function do_upgrade {
    lognotice "Not implemented yet. Skipping."
    return 0
}

## Removes this module.
function do_remove {
    lognotice "Not implemented yet. Skipping."
    return 0
}
