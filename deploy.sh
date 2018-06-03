#!/bin/bash
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
cd ~/read-words
# set this script auto boot with system
installAutoBoot(){
    echo "---> run this to set boot option <---"
    sudo cp ./deploy.sh /etc/init.d
    sudo chmod 755 /etc/init.d/deploy.sh
    cd /etc/init.d
    sudo update-rc.d deploy.sh defaults 90
}

# uninstall auto boot option
uninstallAutoBoot(){
    cd /etc/init.d
    sudo update-rc.d -f test remove
}

# check current workspace
echo ${PWD##*/}
if [ ${PWD##*/}=='read-words' ]
then
    if command -v git >/dev/null 2>&1; then
        echo '---> check workspace successfully <---'
        if git diff-index --quiet HEAD --; then
            # git history is clean, no changes be done, so start building new words...
            echo '---> git history is clean, begin building... <---'
            # pull the changes made by website. (checkboxes)
            git pull
            if [ -d "days" ]; then
                # build the inital table.
                cd ./days
                todayFile=$(date "+%Y-%m-%d.md")
                touch $todayFile
                echo "## English words today: $(date "+%Y-%m-%d")" >> $todayFile
                echo "" >> $todayFile
                echo "| English Words | Word's property | Chinese description |" >> $todayFile
                echo "| :-----------: | :-------------: | :-----------------: |" >> $todayFile
                cd ..
                # load the new words using python3.
                python3 ./loader.py
                cd ./days
                # added the index to the README.md.
                echo '---> new words come today, add them to git <---'
                echo "- [ ] [$(date "+%Y-%m-%d")](./$todayFile)" >> README.md
                cd ..
                # deploy all the changes.
                git add .
                git commit -m "words: added new words today"
                git push -u origin master
            else
                echo '---> first day, build new workspace <---'
                cd /root/read-words # here is your workspace
                mkdir ./days
                cd ./days
            fi
        else
            # git history is no clean, we should add and commit them all, then start building...
            if [ -d "days" ]; then
                # if the git history is not clean, we cannot pull the remote (since it needs a merge).
                git add .
                git commit -m "added: some extra fixes and changes"
                # build the inital table.
                cd ./days
                todayFile=$(date "+%Y-%m-%d.md")
                touch $todayFile
                echo "## English words today: $(date "+%Y-%m-%d")" >> $todayFile
                echo "" >> $todayFile
                echo "| English Words | Word's property | Chinese description |" >> $todayFile
                echo "| :-----------: | :-------------: | :-----------------: |" >> $todayFile
                cd ..
                # load the new words using python3.
                python3 ./loader.py
                cd ./days
                # added the index to the README.md.
                echo '---> new words come today, add them to git <---'
                echo "- [ ] [$(date "+%Y-%m-%d")](./$todayFile)" >> README.md
                cd ..
                # deploy all the changes.
                git add .
                git commit -m "words: added new words today"
                git push -u -f origin master
            else
                echo '---> first day, build new workspace only <---'
                cd /root/read-words # here is your workspace
                mkdir ./days
                cd ./days
            fi
        fi
    else
        echo 'no git exists, please visit https://git-scm.com/downloads to install git first!'
    fi
else
    echo 'You are not in the workspace, will clone new repo automatically!'
    cd ~
    if command -v git >/dev/null 2>&1; then
        echo 'exists git,staring clone...'
        git clone https://github.com:xzbat/read-words.git
        # default clone path: ~
        cd ~/read-words
    else
        echo 'no git exists, please visit https://git-scm.com/downloads to install git first!'
    fi
fi

# run in background
# sudo chmod 755 autoboot.sh
# sudo nohup autoboot.sh &
