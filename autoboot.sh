#!/bin/sh

#Task Time , example:203000(Time 20:30:00);190000(Time 19:00:00);
startTime=001000
program= sh ./deploy.sh

#Section promgram (程序执行部分)
perDate=$(date "+%Y%m%d")
isNewDay=1
isFirstTime=1

echo 'Task schedule Time: ('$startTime') program: ('$program') Waiting...'

while true ; do
    curTime=$(date "+%H%M%S")
    curDate=$(date "+%Y%m%d")

    #Check week day(周末不执行),如不需要可以注释掉
    week=`date +%w`
    if [ $week -eq 6 ] || [ $week -eq 0 ];then
        isNewDay=0
        sleep 1
        continue

    else
        #check and run script(工作日执行)
        if [ "$isNewDay" -eq "1" ];then
            if [ "$curTime" -gt "$startTime" ];then
                if [ "$isFirstTime" -eq "0" ];then
                    echo 'The program ('$program') Running...'
                    $program
                    echo 'The program ('$program') Stopped...'
                fi
                isNewDay=0
            else
                if [ "$isFirstTime" -eq "1" ];then
                    echo 'New Day: ('$curDate') Task schedule Time: ('$startTime') Waiting...'
                    isFirstTime=0
                fi

            fi
        else
            #new day start(开始新的一天)
            if [ "$curDate" -gt "$perDate" ];then
                echo 'New Day: ('$curDate') Task schedule Time: ('$startTime') Waiting...'
                isNewDay=1
                perDate=$curDate
            fi
        fi
        sleep 1
    fi
done
