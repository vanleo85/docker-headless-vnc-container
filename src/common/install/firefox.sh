#!/usr/bin/env bash
set -e

VERSION="102.3.0esr"
echo "Install Firefox $VERSION"

function disableUpdate(){
    ff_def="$1/browser/defaults/profile"
    mkdir -p $ff_def
    cat << EOF > $ff_def/user.js
user_pref("app.update.auto", false);
user_pref("app.update.enabled", false);
user_pref("app.update.lastUpdateTime.addon-background-update-timer", 1182011519);
user_pref("app.update.lastUpdateTime.background-update-timer", 1182011519);
user_pref("app.update.lastUpdateTime.blocklist-background-update-timer", 1182010203);
user_pref("app.update.lastUpdateTime.microsummary-generator-update-timer", 1222586145);
user_pref("app.update.lastUpdateTime.search-engine-update-timer", 1182010203);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("intl.locale.requested", "ru,en-US");
EOF


    ff_distr="$1/distribution"
    mkdir -p "$ff_distr"
    cat << EOF > "${ff_distr}/policies.json"
{
    "policies": {
        "DisableAppUpdate": true,
        "DontCheckDefaultBrowser": true
    }
}
EOF

    ff_pref="$1/defaults/pref"
    mkdir -p "$ff_pref"
    cat <<EOF > "${ff_pref}/autoconfig.js"
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF

    cat <<EOF > "$1/firefox.cfg"
// IMPORTANT: Start your code on the 2nd line
defaultPref("intl.locale.requested", "ru,en-US")
EOF


}

function instFF() {
    if [ ! "${1:0:1}" == "" ]; then
        FF_VERS=$1
        if [ ! "${2:0:1}" == "" ]; then
            FF_INST=$2
            echo "download Firefox $FF_VERS and install it to '$FF_INST'."
            mkdir -p "$FF_INST"
            FF_URL=http://releases.mozilla.org/pub/firefox/releases/$FF_VERS/linux-x86_64/en-US/firefox-$FF_VERS.tar.bz2
            echo "FF_URL: $FF_URL"
            wget -qO- $FF_URL | tar xvj --strip 1 -C $FF_INST/
            ln -s "$FF_INST/firefox" /usr/bin/firefox
            disableUpdate $FF_INST
            exit $?
        fi
    fi
    echo "function parameter are not set correctly please call it like 'instFF [version] [install path]'"
    exit -1
}

instFF "$VERSION" '/usr/lib/firefox'