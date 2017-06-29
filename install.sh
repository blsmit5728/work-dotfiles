#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=`pwd`                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="mybashrc vimrc screenrc colors forward"    # list of files/folders to symlink in homedir
REMOVE_ME="Documents Music Pictures Templates Videos"

function ubuntu {
	# create dotfiles_old in homedir
    echo -ne "Creating $olddir for backup of any existing dotfiles in ~"
    mkdir -p $olddir
    echo "...done"

	# change to the dotfiles directory
    echo -ne "Changing to the $dir directory"
    cd $dir
    echo "...done"

    # make a temp dir for us to do rando ass work in.
    mkdir /home/$USER/temp
    # make a cron job that cleans out that dir every night
    line="00 00 * * * rm -rf /home/bsmith/temp/*"
    (crontab -l; echo "$line" ) | crontab -

	# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
    for file in $files; do
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv ~/.$file ~/dotfiles_old/
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    done
    echo "source ~/.mybashrc" >> ~/.bashrc

    # remove all the crappy defualt dirs..
    for R_DIR in $REMOVE_ME
    do
        rm -rfv /home/$USER/$R_DIR
    done
    
    #create the src directory
    if [ -e /home/$USER/src ]
    then
        echo "/home/$USER/src/ already exists..."
    else
        echo "Making src directory"
        mkdir /home/$USER/src/
    fi
}

function osx {
    if [ -e ~/.bash_profle ]
    then
        cp bash_profile_osx ~/.my_bash_profile
        echo "source ~/.my_bash_profile" >> ~/.bash_profle
    else
	    cp bash_profile_osx ~/.bash_profle
    fi
}


# Grep to see if we are on OSX or something else

uname -a | grep Darwin --color=auto >> /dev/null 
if [ $? -eq "0" ]
then 
	# This is an OSX machine
    osx
else 
	# this is something else, not OSX
    ubuntu
fi



	
