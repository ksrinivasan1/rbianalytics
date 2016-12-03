#! /bin/bash
cwd=$PWD
declare -a years=(2009 2010 2011 2012 2013 2014 2015 2016)

for y in `echo ${years[@]}`
do
  echo ${y}
   for f in `cat ${cwd}/extract/${y}.html | grep -io "[0-9A-Za-z]*.XLS" | grep -v "Images"`
      do
   	wget https://rbidocs.rbi.org.in/rdocs/NEFT/DOCs/$f -o ${cwd}/downloads/$y/$f
        echo $y/$f
      done
done

