#!/bin/bash

servers='
web01
web02
web03
'

check=''

for c in $servers ; do
  yumpackages=`ssh -F ./ssh_config $c rpm -qa`
  today=`date +%s`
  week=684800

    for i in $yumpackages ;do
      installed=`ssh -F ./ssh_config $c rpm -q $i --queryformat "%{INSTALLTIME}" `

      if [ $(($week + $installed)) -gt $today ]; then
         if [ !-n $check ]; then
            check="YES"
         fi
        ymd=`date --date "@$installed"`
        echo "$i | $ymd"  >> $$.txt
      fi

    done
done

if [[ $check = "YES" ]]; then
  cat $$.txt
  exit 2
else
  exit 0
fi
