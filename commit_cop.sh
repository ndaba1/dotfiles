#!/bin/bash

function add_dir {
    if [[ -d ".git" ]]; then
        for dir in $(cat ~/.my_repos)
         do
            if [[ $(pwd) == $dir ]]; then
                echo "FAILED. Directory \"`pwd`\" already tracked. Aborting..."
                return
            fi
         done
        echo `pwd` >> ~/.my_repos
        echo "Successfully added directory: \"`pwd`\""
    else 
        echo "FAILED. Directory: \"`pwd`\" not initialized with git"
    fi
}

function add_recursive_dir() {
    LEVEL=$1

    if [ $LEVEL -eq 1 ]; then
       for e in $(ls)
         do
            cd "$(pwd)/$e"
            add_dir
            cd ..
         done
    elif [ $LEVEL -eq 2 ]; then
        for e1 in $(ls)
         do
            cd $e1
            add_recursive_dir 1
            cd ..
        done
    fi
}

if [[ $1 == "add" ]]; then
    if [[ $2 == "-r" ]]; then
        add_recursive_dir 1
    elif [[ $2 == "-dev" ]]; then
        add_recursive_dir 2
    else
        add_dir
    fi
elif [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "commit-cop"
    echo "A simple script for counting daily commits from given directories"
    echo ""

    echo "Arguments:"
    echo -n "    "
    echo -n "add"
    echo -n "       "
    echo "Adds the current directory to the '~/.my_repos' file to be tracked."

    echo -n "    "
    echo -n "add -r"
    echo -n "    "
    echo "Recursively adds sub-directories in working dir to the '~/.my_repos' file to be tracked."
    echo ""

    echo -n "    "
    echo -n "add -dev"
    echo -n "    "
    echo "Recursively adds sub-dirs of sub-dirs in working dir to the '~/.my_repos' file to be tracked."
    echo ""

    echo "Run the script without arguments to count all the total commits of the day 
accross all the tracked repositories."
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

