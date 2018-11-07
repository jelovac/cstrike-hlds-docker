#!/usr/bin/env bash

set -axe

CONFIG_FILE="/opt/hlds/startup.cfg"

if [ -r "${CONFIG_FILE}" ]; then
    # TODO: make config save/restore mechanism more solid
    set +e
    # shellcheck source=/dev/null
    source "${CONFIG_FILE}"
    set -e
fi

EXTRA_OPTIONS=( "$@" )

EXECUTABLE="/opt/hlds/hlds_run"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MAP="${START_MAP:-de_dust2}"
SERVER_NAME="${SERVER_NAME:-Counter-Strike 1.6 Server}"

OPTIONS=( "-game" "cstrike" "+maxplayers" "${MAXPLAYERS}" "+map" "${START_MAP}" "+hostname" "\"${SERVER_NAME}\"")

if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS+=('-norestart')
fi

if [ -n "${SERVER_ADMIN_STEAM_ID}" ]; then

    set +e
    adminAlreadyAdded=$(cat "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini" | grep -c "${SERVER_ADMIN_STEAM_ID}")
    set -e

    if [ $adminAlreadyAdded -eq 0 ]; then
        echo "\"STEAM_${SERVER_ADMIN_STEAM_ID}\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" > "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini"
    fi

fi

set > "${CONFIG_FILE}"

exec "${EXECUTABLE}" "${OPTIONS[@]}" "${EXTRA_OPTIONS[@]}"
