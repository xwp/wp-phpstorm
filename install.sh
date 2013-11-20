#!/bin/bash

cd $(dirname $0)
repo_dir=$(pwd)

if [ "$(uname)" == "Darwin" ]; then
    user_config_dir="/Library/Preferences/WebIde"    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    user_config_dir="$HOME/.WebIde"
#elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    #user_config_dir="?"
fi

webide_dir=`$(which ls) -d $user_config_dir* | tail -n 1`/config

if [ ! $webide_dir ]; then
    echo "Could not find WebId* directories"
    exit
fi

if [ ! -L $webide_dir/options/project.default.xml ]; then
    echo "Installing project.default.xml"
    if [ -e $webide_dir/options/project.default.xml ]; then
        mv $webide_dir/options/project.default.xml{,-backup-$(date "+%Y%m%dT%H%M%S")}
    fi
    cd $webide_dir/options/
    ln -s $repo_dir/project.default.xml .
    cd $repo_dir
fi

if [ ! -e ~/.jshintrc ]; then
    echo "Add default ~/.jshintrc"
    curl -L https://raw.github.com/x-team/wp-plugin-dev-lib/master/.jshintrc > ~/.jshintrc
fi

if [ ! -e $webide_dir/codestyles/WordPress.xml ]; then
    echo "Install WordPress coding style"
    cd $webide_dir/codestyles
    ln -s $repo_dir/codestyles/WordPress.xml .
    cd $repo_dir
fi
