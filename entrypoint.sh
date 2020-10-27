#!/bin/bash

BOXJSON_DIR=${BOXJSON_DIR:-""}
FULL_DIR="${GITHUB_WORKSPACE}${BOXJSON_DIR}"
BOX_JSON_FILE="${FULL_DIR}/box.json"
DO_ENV_SUBSTITUTION="true"

if [[ -z "$INPUT_FORGEBOX_USER" ]] || [[ -z "$INPUT_FORGEBOX_PASS" ]] ; then
	echo "Forgebox environment variables not set. Please set both FORGEBOX_USER and FORGEBOX_PASS environment variables to use this action."
	exit 1
fi

if [[ -f $BOX_JSON_FILE ]] ; then
	if [[ -n "${INPUT_VERSION_NUMBER}" ]] ; then
		sed -i "s,{VERSION_NUMBER},$INPUT_VERSION_NUMBER," $BOX_JSON_FILE
	fi
	if [[ -n "${INPUT_DOWNLOAD_LOCATION}" ]] ; then
		sed -i "s,{DOWNLOAD_LOCATION},$INPUT_DOWNLOAD_LOCATION," $BOX_JSON_FILE
	fi

	echo "Publishing box.json to Forgebox:"
	echo "--------------------------------"
	cat $BOX_JSON_FILE
	echo "--------------------------------"


	box forgebox login username="$INPUT_FORGEBOX_USER" password="$INPUT_FORGEBOX_PASS" || exit 1;
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