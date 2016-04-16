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
		grep -E "(TweetTextSize)|(js-retweet-text)" temp | sed -n '/^$/!{s/<[^>]*>//g;p;}' | tr '[:upper:]' '[:lower:]' > feed
		grep -oh "[0-9][0-9]\.[0-9][0-9] - [0-9][0-9]* [A-Z][a-z][a-z] [0-9][0-9][0-9][0-9]" temp  | uniq| sed '1d' > tgl
		rt=false
		> temp
		while 
		read line
		do
		if [[ "$line" =~ "retweet" ]]
		then
		rt=true	
		continue	
		fi
		if [ "$rt" = true ]
		then
		echo " rt $line"
		echo " rt $line" >> temp	
		rt=false
		else
		echo "$line"
		echo "$line" >> temp
		fi	
		
		
		done < feed
		paste tgl temp  > "res/$nama-$now-t.tsv"
		rm tgl feed temp
	fi
fi 
done < $1 

# <span class="js-retweet-text"
