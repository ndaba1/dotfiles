#! /bin/bash

git log | grep "$(date +'%a %b %-d')" | wc -l 
