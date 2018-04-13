#!/usr/bin/env bash

# source this file to load some useful funcitons into your shell

# print a list of git fetch commands for all paths in the current working directory
function git_fetch_origins() {
    find . -mindepth 1 -maxdepth 1 -type d | while read repo; do cd $repo; git remote get-url origin; cd .. ; done
}
