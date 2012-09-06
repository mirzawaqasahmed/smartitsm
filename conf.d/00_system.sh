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


## Base System


MODULE="system"
TITLE="Base System"
DESCRIPTION="system preparation"
PRIORITY="00"


## Installs this module.
function do_install {
    loginfo "Executing pre-checks..."

    logdebug "Checking user rights..."
    local user=`whoami`
    if [ "$user" != "root" ]; then
        logwarning "You need super user (root) rights."
        return 1
    fi

    logdebug "Checking distribution..."
    local release=`lsb_release --all 2> /dev/null | grep "Release" | awk '{print $NF}'`
    if [ "$?" -gt 0 ]; then
        logwarning "lsb_release is not available or returned with an error."
        return 1
    fi
    if [ "$release" != "12.04" ]; then
        logwarning "Distribution Ubuntu 12.04 LTS is required."
        return 1
    fi

    logdebug "Pre-checks are done."

    loginfo "Appending hostname to /etc/hosts..."
    echo -e "\n127.0.0.1\t$HOST\n" >> /etc/hosts || return 1
    
    loginfo "Renaming hostname in /etc/hostname..."
    echo -e "$HOST\n" > /etc/hostname || return 1
    
    loginfo "Upgrading system..."
    upgradeSystem || return 1
    
    loginfo "Installing packages..."
    # TODO Use automatically MySQL DBA credentials to configure mysql-server package:
    installPackage "joe htop make python-software-properties rcconf pwgen unzip subversion git pandoc imagemagick apache2 libapache2-mod-perl2 php5 php5-cli php5-curl php5-gd php5-imagick php5-ldap php5-mcrypt php5-mysql php5-pgsql php5-suhosin php5-xcache php5-xdebug php-pear php5-xmlrpc php5-xsl mysql-server mysql-client libgd-gd2-perl graphviz libexpat1-dev perl-doc nmap librrds-perl rrdtool" || return 1
    
    loginfo "Tweaking MySQL server configuration..."
    echo "[mysqld]
key_buffer_size=64M
table_open_cache=1024
sort_buffer_size=4M
read_buffer_size=1M
" > /etc/mysql/conf.d/smartitsm.cnf || return 1
    service mysql restart || return 1
    
    loginfo "Tweaking PHP configuration for Apache httpd..."
    echo "max_execution_time = 300
max_input_time = 60
memory_limit = 1024M
error_reporting = E_ALL & ~E_DEPRECATED
display_errors = Off
log_errors = On
html_errors = Off
post_max_size = 128M
upload_max_filesize = 128M
session.gc_maxlifetime = 86400
" > /etc/php5/apache2/conf.d/smartitsm.ini || return 1
    service apache2 restart || return 1

    loginfo "Installing NTP deamon..."
    apt-get autoremove --purge -y ntpdate || return 1
    installPackage "ntp" || return 1

    loginfo "Installing phpMyAdmin (after MySQL server has been started)..."
    # TODO Use automatically apache2 as prefered webserver.
    # TODO Say "Yes" to run dbconfig-common.
    # TODO Use automatically MySQL DBA user's password.
    # TODO Leave field empty for phpMyAdmin user.
    installPackage "phpmyadmin" || return 1
    echo -e "
\$cfg['MaxTableList'] = 1024;
\$cfg['SuhosinDisableWarning'] = true;
\$cfg['LoginCookieValidity'] = 86400;
\$cfg['LoginCookieStore'] = 86400;
" >>

    loginfo "Installing OpenLDAP and phpLDAPAdmin..."
    # TODO Set automatically LDAP admin password:
    installPackage "slapd ldap-utils phpldapadmin" || return 1

    ## Apache httpd
    loginfo "Tweaking Apache httpd configuration..."
    a2enmod rewrite || return 1
    echo -e "\nServerName $HOST\n" >> /etc/apache2/apache2.conf || return 1
    
    loginfo "Creating some important directories..."
    mkdir -p "$SMARTITSM_ROOT_DIR" || return 1
    mkdir -p "$TMP_DIR" || return 1
    
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
    upgradeSystem || return 1
    return 0
}

## Removes this module.
function do_remove {
    lognotice "Not implemented yet. Skipping."
    return 0
}
