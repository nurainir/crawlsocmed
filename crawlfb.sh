#!/bin/bash -l
IFS="," 
while 
read f1 f2 
do 
nama=`echo $f1 |  tr ' ' '-' | tr '\t' '-'`
echo "page $nama" 
url=${f2%?}
if [ "$url" != "-" ]
then
	status=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)" -w "%{http_code}" -o temp -L --silent "$url")
	echo $status
grep '5pbx userContent' temp | perl -pe 's/5pbx userContent/\n5pbx userContent/g' > temp1
grep -Eoh  '<p>(.*?)</p>' temp1 | sed -n '/^$/!{s/<[^>]*>//g;p;}' > feed
grep -Eoh 'data-utime="[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' temp1 | sed -r 's/^.{12}//' > tgl
> tgl1
while 
read line
do 
date -d @$line +"%d-%m-%y %T" >> tgl1
done < tgl
baristgl=`wc -l < tgl`
barisfeed=`wc -l < feed`
val=`expr $baristgl - $barisfeed`
v="1,"
var="${val}d"
val=$v$var
sed "$val" tgl1 > tgl 
paste tgl feed > res/$nama-fb
fi 
done < $1
rm tgl1 temp1 temp tgl feed
