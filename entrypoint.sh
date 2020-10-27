#!/bin/bash

BOXJSON_DIR=${BOXJSON_DIR:-""}
FULL_DIR="${GITHUB_WORKSPACE}${BOXJSON_DIR}"
BOX_JSON_FILE="${FULL_DIR}/box.json"
DO_ENV_SUBSTITUTION="true"

if [[ -z "$FORGEBOX_USER" ]] || [[ -z "$FORGEBOX_PASS" ]] ; then
	echo "Forgebox environment variables not set. Please set both FORGEBOX_USER and FORGEBOX_PASS environment variables to use this action."
	exit 1
fi

if [[ -f $BOX_JSON_FILE ]] ; then
	if [[ "$DO_ENV_SUBSTITUTION" == "true" ]] ; then
		envsubst < $BOX_JSON_FILE > $BOX_JSON_FILE.substituted
		rm $BOX_JSON_FILE
		mv $BOX_JSON_FILE.substituted $BOX_JSON_FILE
	fi

	box forgebox login username="$FORGEBOX_USER" password="$FORGEBOX_PASS" || exit 1;
	box publish directory="$FULL_DIR" || exit 1;

	echo ""
	echo "------------------"
	echo "ALL DONE. SUCCESS."
	echo "------------------"
	echo ""
else
	echo "No box.json file found at: $BOX_JSON_FILE. Not publishing."
	exit 1
fi