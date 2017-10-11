#!/bin/bash

gcheckoutsextended.sh | grep -oP "\s[^\s]+$"
