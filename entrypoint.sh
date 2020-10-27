#!/bin/bash

BOXJSON_DIR=${BOXJSON_DIR:-""}
FULL_DIR="${GITHUB_WORKSPACE}${BOXJSON_DIR}"
BOX_JSON_FILE="${FULL_DIR}/box.json"
DO_ENV_SUBSTITUTION="true"

if [[ -z "$forgebox_user" ]] || [[ -z "$forgebox_pass" ]] ; then
	echo "Forgebox environment variables not set. Please set both forgebox_user and forgebox_pass environment variables to use this action."
	exit 1
fi

if [[ -f $BOX_JSON_FILE ]] ; then
	if [[ "$DO_ENV_SUBSTITUTION" == "true" ]] ; then
		envsubst < $BOX_JSON_FILE > $BOX_JSON_FILE.substituted
		rm $BOX_JSON_FILE
		mv $BOX_JSON_FILE.substituted $BOX_JSON_FILE
	fi

	echo "Publishing box.json to Forgebox:"
	echo "--------------------------------"
	cat $BOX_JSON_FILE
	echo "--------------------------------"


	box forgebox login username="$forgebox_user" password="$forgebox_pass" || exit 1;
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