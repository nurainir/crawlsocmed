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
	echo $status
#<script type="text/javascript">window._sharedData 
grep 'window._sharedData' temp | sed -r 's/^.{52}//' | sed -r 's/.{11}$//'   > res/$nama-insta.json

fi 
done < $1
rm  temp

