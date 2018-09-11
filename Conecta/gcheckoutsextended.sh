#!/bin/bash

git reflog --pretty="%gs" | grep "checkout: moving from" | sed -e "s/^checkout: moving from//" -e "s/ to / --> /" | tac
