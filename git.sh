#!/bin/bash

set -e
trap 'echo "Error in  line $LINENO: $BASH_COMMAND (code: $?)"; read -p "Following? (y/n): " CONT; [ "$CONT" != "y" ] && exit 1' ERR

echo -e "==========================Git Branch=========================="
read -p "Do you need see branches: Write (y/all); " BRANCHES
if [ "$BRANCHES" == "y" ]; then
    echo "Showing local branches:"
    git branch
elif [ "$BRANCHES" == "all" ]; then
    echo "Showing all branches including remote:"
    git branch -a
else
    echo "Skipping branch listing."
fi

status_funtion() {
    echo -e "==========================Status=========================="
    git status
}

add_funtion() {
    echo -e "==========================Add=========================="
    read -p "Do you want to add all changes? (y/n): " ADD_ALL
    if [ "$ADD_ALL" == "y" ]; then
        git add .
        git status
        git commit -m "Update project files"
    else
        echo "Skipping adding all changes."
        git stash 
    fi
}

status_funtion
add_funtion

branch_funtion() {
    echo -e "==========================Branch=========================="
    read -p "Enter your branch name: " BRANCH
    if [ -z "$BRANCH" ]; then
            echo "Skipping branch switch."
            echo "Current branch is: $(git branch --show-current)"
        else
            echo "Switching to branch: $BRANCH"
            git checkout $BRANCH
            echo -e "==========================Fetch=========================="
            git fetch origin $BRANCH
            echo -e "==========================Pull=========================="
            read -p "Do you need to pull changes from remote? (y/n): " PULL
            if [ "$PULL" == "y" ]; then
                git pull origin $BRANCH
            fi
            
    fi
}

branch_funtion
status_funtion

echo -e "==========================Push to GitHub=========================="
read -p "Push to GitHub; Wtite y; " GITHUB
if [ "$GITHUB" == "y" ]; then
    Current_BRANCH=$(git branch --show-current)
    git push origin $Current_BRANCH
fi