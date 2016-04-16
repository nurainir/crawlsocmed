#!/bin/bash -l
IFS="," 
while 
read f1 f2 
do 
nama=`echo $f1 |  tr ' ' '-' | tr '\t' '-'`
echo "id $nama" 
url=${f2%?}
if [ "$url" != "-" ]
then
	status=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)" -w "%{http_code}" -o temp -L --silent "$url")
	if [[ "$status" =~ "200" ]]
	then
	now=$(date +"%d-%m-%y-%H-%M")
	grep 'window._sharedData' temp | sed -r 's/^.{52}//' | sed -r 's/.{11}$//' > temp1
	grep -Po '"date":.*?[^\\]",' temp1 | grep "caption" > temp
	grep -Eoh '"date":[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' temp | sed -r 's/^.{7}//' > tgl
	grep -Po '"caption":.*?[^\\]",' temp | sed -r 's/^.{11}//' | sed -r 's/.{2}$//'> feed
	> tgl1
	while 
	read line
	do 
		date -d @$line +"%d-%m-%y %T" >> tgl1
	done < tgl
	paste tgl1 feed | tr '[:upper:]' '[:lower:]'> res/$nama-$now-i.tsv
	rm  temp temp1 feed tgl1 tgl
	fi
fi 
done < $1


