#! /bin/bash
name=david
age=19
echo my name is $name, I am $[age+1] years old, I love CLI, which make me look like a pro

var=$((100/18))
echo "scale=2;$var" | bc

read -p "Enter your name: " usr_name
read -p "Enter your age: " usr_age
echo Hello $usr_name, you are $usr_age

if [ $usr_age -gt $age ]
	then 
		ygap=$((usr_age - age))
		echo you are $ygap years older than me
elif [ $usr_age -lt $age ]
	then
		ygap=$((usr_age - age))
		echo you are $ygap years youger than me
elif [ $usr_age -eq $age ]
	then
		ygap=$((usr_age - age))
                echo you were born the same years as me
fi
for i in {1..4}
do 
	echo "hello World the $i times"
done

for x in hello world
do	
	echo $x
done

# While loop 
i=1
while [[ $i -le 3 ]] ; do
	echo "$i"
	(( i += 1))	
done

read -p "please insert the file you want to read: " usr_file

LINE=1
while read -r CURRENT_LINE
	do
	       echo "$LINE: $CURRENT_LINE"
	       ((LINE++))	
       done < $usr_file      
# Read all the .csv files within this directory
# csv_files = `ls | grep *.csv
csv_files=`ls | grep *.csv`
echo $csv_files
CSV_LINES=1
while read -r CSV_CURRENT && [[ CSV_LINES -lt 4 ]]; do
	echo "$CSV_LINES: $CSV_CURRENT"
	((CSV_LINES++))
done <<< "$csv_files"
# Or we can use <<< for string redirection
for x in $@ 
do 
	echo "ENter arg is $x"
done
