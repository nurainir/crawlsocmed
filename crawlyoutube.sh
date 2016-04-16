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
		 grep "yt-lockup-title" temp | grep -Eoh 'title=".*"  a'| sed -r 's/^.{7}//' | sed -r 's/.{4}$//' > feed
		 grep "yt-lockup-meta-info" temp | grep -Eoh "</li><li>.*</li></ul>" | sed -r 's/^.{9}//' | sed -r 's/.{10}$//' > tgl
		paste tgl feed | tr '[:upper:]' '[:lower:]'> res/$nama-$now-y.tsv
	fi
fi 
done < $1 
	

