#!/bin/bash

if [[ $1 == "add" ]]; then
    echo `pwd` >> ~/.my_repos
    echo "Successfully added directory: `pwd`"
else 
    TOTAL_COMMITS=0
    # count total commits
    for dir in $(cat ~/.my_repos)
     do
        cd $dir
        LOCAL=$(git log | grep "$(date +'%a %b %-d')" | wc -l)
        echo "$LOCAL total commits in $dir"
        TOTAL_COMMITS=$(($TOTAL_COMMITS + $LOCAL ))
    done
    echo ""
    echo "Today's total commits: $TOTAL_COMMITS"
fi