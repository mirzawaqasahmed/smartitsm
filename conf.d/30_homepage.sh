#!/bin/bash


## smartITSM Demo System
## Copyright (C) 2014 synetics GmbH <http://www.smartitsm.org/>
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


## Homepage of smartITSM Demo System


MODULE="homepage"
TITLE="Homepage of smartITSM Demo System"
DESCRIPTION="Each module has its on entry."
PRIORITY="30"


## Installs this module.
function do_install {
    do_www_install || return 1
    return 0
}

## Installs homepage configuration.
function do_www_install {
    loginfo "Installing homepage configuration..."
    cp -r "$WWW_DIR" "$SMARTITSM_ROOT_DIR" || return 1
    mkdir -p "$LOGO_DIR" || return 1
    mkdir -p "$WWW_MODULE_DIR" || return 1
    cp "$ETC_DIR"/apache.conf /etc/apache2/conf-available/smartitsm_homepage.conf || return 1
    a2enconf smartitsm_homepage
    restartWebServer || return 1
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
