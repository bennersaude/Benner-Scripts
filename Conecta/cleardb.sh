#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Missing database name. Try again passing 'databaseName' as the first parameter."
	exit 1
fi

sqlcmd -E -S localhost -Q "ALTER DATABASE $1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;DROP DATABASE $1;CREATE DATABASE $1 COLLATE Latin1_General_CI_AI"
